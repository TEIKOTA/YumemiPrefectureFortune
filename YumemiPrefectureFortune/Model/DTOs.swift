import Foundation

// MARK: - Request DTO
/// year, month, day を持つJSONの日付表現のための構造体
struct YMD: Codable, Equatable {
    let year: Int
    let month: Int
    let day: Int
}

struct FortuneRequestDTO: Encodable {
    let name: String
    let birthday: YMD
    let bloodType: String
    let today: YMD
}

// MARK: - Response DTO

struct FortuneResult: Decodable {
    let prefecture: Prefecture
}
