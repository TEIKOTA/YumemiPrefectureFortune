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
    
    func fetchFortune(from requestDTO: FortuneRequestDTO) async throws -> FortuneResult {
    }
}
