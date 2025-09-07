import Foundation


struct FortuneRequestDTO {
    var name: String
    var birthday: Date
    var bloodType: String
    var today: Date
}

struct FortuneResult {
    var prefecture: Prefecture
}
