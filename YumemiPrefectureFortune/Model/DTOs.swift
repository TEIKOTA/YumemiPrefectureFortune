import Foundation

// MARK: - Request DTO
/// year, month, day を持つJSONの日付表現のための構造体
struct YMD: Codable, Equatable {
    let year: Int
    let month: Int
    let day: Int
    
    init(date: Date) {
        let calendar = Calendar.current
        
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
}

struct FortuneRequestDTO: Encodable {
    let name: String
    let birthday: YMD
    let bloodType: String
    let today: YMD
    
    init(user: UserProfile) {
        self.name = user.name
        self.birthday = YMD(date: user.birthday)
        self.bloodType = user.bloodType.rawValue
        self.today = YMD(date: Date())
    }
    
    init(name: String, birthday: YMD, bloodType: String, today: YMD) {
        self.name = name
        self.birthday = birthday
        self.bloodType = bloodType
        self.today = today
    }
}

// MARK: - Response DTO

struct FortuneResult: Decodable {
    let prefecture: Prefecture
    
    init(prefecture: Prefecture) {
        self.prefecture = prefecture
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.prefecture = try container.decode(Prefecture.self)
    }
}
