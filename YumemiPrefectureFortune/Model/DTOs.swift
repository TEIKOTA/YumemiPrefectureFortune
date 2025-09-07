import Foundation

// MARK: - Request DTO

struct FortuneRequestDTO: Encodable {
    var name: String
    var birthday: Date
    var bloodType: String
    var today: Date
}

// MARK: - Response DTO

struct FortuneResult: Decodable {
    var prefecture: Prefecture
}
