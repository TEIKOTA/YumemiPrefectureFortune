import SwiftUI
import SwiftData


final class FortuneProfileFormViewModel: ObservableObject {
    
    @Published var name: String?
    @Published var birthday: Date?
    @Published var bloodType: BloodType?
    @Published var introduction: String?
    @Published var icon: Data?
    
    // 存在するなら編集、nilなら新規
    private var existingProfile: UserProfile?
    
    init(user: UserProfile?) {
        
        guard let user else { return }
        
        self.name = user.name
        self.birthday = user.birthday
        self.bloodType = user.bloodType
        self.introduction = user.introduction
        self.icon = user.icon
        
        self.existingProfile = user
    }
    
    func save() throws -> UserProfile {
        
        // 未入力の場合を弾く
        guard let name = name, !name.isEmpty else {
            throw ValidationError.missingField(field: "Name")
        }
        
        guard let birthday = birthday else {
            throw ValidationError.missingField(field: "birthday")
        }
        
        guard let bloodType = bloodType else {
            throw ValidationError.missingField(field: "bloodType")
        }
        
        if let existingProfile {
            
            existingProfile.update(name: name,
                                   birthday: birthday,
                                   bloodType: bloodType,
                                   introduction: introduction,
                                   icon: icon)
            return existingProfile
            
        }else {
            
            let newUserProfile = UserProfile(
                name: name,
                birthday: birthday,
                bloodType: bloodType,
                introduction: introduction,
                icon: icon
            )
            return newUserProfile

        }
    }
}

enum ValidationError: Error {
    case missingField(field: String)
}
