import Foundation


struct UserProfile {
    var id: UUID
    var name: String
    var birthday: Date
    var bloodType: BloodType
    var introduction: String?
    var icon: Data?
    var fortuneResult: FortuneResult
}
