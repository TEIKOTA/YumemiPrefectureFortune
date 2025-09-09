import Foundation
import os.lock

final class MockURLProtocol: URLProtocol {

    typealias RequestHandler = (URLRequest) throws -> (HTTPURLResponse, Data?)

    // A queue of handlers. Tests will append their handlers to this queue.
    private static var handlerQueue: [RequestHandler] = []
    private static let lock = OSAllocatedUnfairLock()

    /// Adds a handler to the end of the queue.
    static func setHandler(handler: @escaping RequestHandler) {
        lock.withLock {
            handlerQueue.append(handler)
        }
    }

    // The handler for this specific request instance.
    private var instanceHandler: RequestHandler?

    // MARK: - URLProtocol Overrides

    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        // Dequeue the next handler.
        self.instanceHandler = Self.lock.withLock {
            guard !Self.handlerQueue.isEmpty else {
                return nil
            }
            return Self.handlerQueue.removeFirst()
        }
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        // We can handle the request if there is a handler in the queue.
        return lock.withLock { !handlerQueue.isEmpty }
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = self.instanceHandler else {
            // This can happen if multiple requests are fired for a single setHandler call.
            // Or if canInit returns true but the handler is dequeued by another thread before init is called.
            let error = URLError(.unknown, userInfo: [NSLocalizedDescriptionKey: "MockURLProtocol handler was not found. It might have been consumed by another request."])
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // Nothing to do.
    }
}