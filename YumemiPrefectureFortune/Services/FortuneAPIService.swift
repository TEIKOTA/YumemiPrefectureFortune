import Foundation

// MARK: - API Error

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case badStatusCode(Int)
    case decodingError(Error)
}
