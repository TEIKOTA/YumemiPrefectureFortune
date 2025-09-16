import Foundation

// MARK: - API Error

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case badStatusCode(Int)
    case decodingError(Error)
}

// MARK: - Service Protocol

/// 占いAPIサービスクラスが準拠するプロトコル
/// これを定義することで、テスト時にモックを注入しやすくなる
protocol FortuneAPIServiceProtocol {
    func fetchFortune(from requestDTO: FortuneRequestDTO) async throws -> FortuneResult
}

 // MARK: - Service Implementation

 /// 占いAPIとの通信を実際に担当するクラス
final class FortuneAPIService: FortuneAPIServiceProtocol {
    
    private let session: URLSession

    // テスト時に外部からURLSessionを注入できるようにする
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchFortune(from requestDTO: FortuneRequestDTO) async throws -> FortuneResult {
        guard let url = URL(string: "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud/my_fortune") else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("v1", forHTTPHeaderField: "API-Version")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        urlRequest.httpBody = try encoder.encode(requestDTO)
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await self.session.data(for: urlRequest)
        } catch {
            throw APIError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw APIError.badStatusCode(statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(FortuneResult.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
