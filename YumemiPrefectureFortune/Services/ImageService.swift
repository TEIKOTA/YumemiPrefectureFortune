import UIKit

// MARK: - ImageServiceError
enum ImageServiceError: Error, Equatable {
    case invalidURL
    case networkError(Error)
    case badStatusCode(Int)
    case decodingError(Error)
    case noImageFound
    case dataConversionError
    
    static func == (lhs: ImageServiceError, rhs: ImageServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.networkError, .networkError):
            // ErrorはEquatableではないため、ケースのみを比較
            return true
        case (.badStatusCode(let l), .badStatusCode(let r)):
            return l == r
        case (.decodingError, .decodingError):
            // ErrorはEquatableではないため、ケースのみを比較
            return true
        case (.noImageFound, .noImageFound):
            return true
        case (.dataConversionError, .dataConversionError):
            return true
        default:
            return false
        }
    }
}

// MARK: - Pixabay API Response DTOs
private struct PixabayResponse: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [ImageHit]
}

private struct ImageHit: Decodable {
    let webformatURL: URL
}

// MARK: - ImageServiceProtocol
protocol ImageServiceProtocol {
    func fetchImage(from url: URL) async throws -> UIImage
    func searchImage(for query: String) async throws -> UIImage
}

// MARK: - ImageService
final class ImageService: ImageServiceProtocol {

    private let session: URLSession
    private let apiKey: String
    private let cache = NSCache<NSString, UIImage>()

    /// For production use, reads the API key from the app's bundle (Info.plist).
    init(session: URLSession = .shared, bundle: Bundle = .main) {
        self.session = session
        guard let apiKey = bundle.object(forInfoDictionaryKey: "PIXABAY_API_KEY") as? String, !apiKey.isEmpty else {
            fatalError("PixabayAPIKey not found in Info.plist. Please set it up in Secrets.xcconfig and link it in the project settings.")
        }
        self.apiKey = apiKey
    }

    /// For testing purpose.
    internal init(session: URLSession, apiKey: String) {
        self.session = session
        self.apiKey = apiKey
    }

    func fetchImage(from url: URL) async throws -> UIImage {

        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        }

        let (data, _) = try await handleNetworkRequest {
            try await self.session.data(from: url)
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageServiceError.dataConversionError
        }

        self.cache.setObject(image, forKey: url.absoluteString as NSString)

        return image
    }

    func searchImage(for query: String) async throws -> UIImage {

        guard var components = URLComponents(string: "https://pixabay.com/api/") else {
            throw ImageServiceError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "lang", value: "ja"),
            URLQueryItem(name: "editors_choice", value: "true"),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "orientation", value: "horizontal"),
            URLQueryItem(name: "per_page", value: "3"), // 最初の1件だけあれば良いが範囲は3〜200なので最小の3
        ]

        guard let url = components.url else {
            throw ImageServiceError.invalidURL
        }

        let (data, _) = try await handleNetworkRequest {
            try await self.session.data(from: url)
        }

        do {
            let response = try JSONDecoder().decode(PixabayResponse.self, from: data)
            guard let firstHit = response.hits.first else {
                throw ImageServiceError.noImageFound
            }
            return try await fetchImage(from: firstHit.webformatURL)
        } catch let error as ImageServiceError {
            throw error
        } catch {
            throw ImageServiceError.decodingError(error)
        }
    }
    
    private func handleNetworkRequest(
        _ request: () async throws -> (Data, URLResponse)
    ) async throws -> (Data, URLResponse) {
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await request()
        } catch {
            throw ImageServiceError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw ImageServiceError.badStatusCode(statusCode)
        }
        
        return (data, response)
    }
}

