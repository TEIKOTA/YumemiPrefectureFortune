import SwiftUI
import SwiftData


final class FortuneProfileFormViewModel: ObservableObject {
    @Published var name: String?
    @Published var birthday: Date?
    @Published var bloodType: BloodType?
    @Published var introduction: String?
    @Published var icon: Data?
    
    init(user: UserProfile?) {
        
        guard let user else { return }
        
        self.name = user.name
        self.birthday = user.birthday
        self.bloodType = user.bloodType
        self.introduction = user.introduction
        self.icon = user.icon
    }
}
