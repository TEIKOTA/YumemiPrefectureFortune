import SwiftUI
import PhotosUI
import SwiftData


final class FortuneProfileFormViewModel: ObservableObject {
    
    @Published var name: String?
    @Published var birthday: Date?
    @Published var bloodType: BloodType?
    @Published var introduction: String?
    @Published var icon: Data?
    // UI表示用のUIImage型プロパティ
    @Published var iconImage: UIImage?
    @Published var mode: ProfileFormMode

    
    init(user: UserProfile?) {
        
        guard let user else {
            self.mode = .create
            return
        }
        
        self.name = user.name
        self.birthday = user.birthday
        self.bloodType = user.bloodType
        self.introduction = user.introduction
        self.icon = user.icon
        
        self.mode = .edit(user)
    }
    
    func save() throws -> UserProfile {
        
        // 未入力の場合を弾く
        guard let name = name, !name.isEmpty else {
            throw ValidationError.missingField(field: "名前")
        }
        
        guard let birthday = birthday else {
            throw ValidationError.missingField(field: "誕生日")
        }
        
        guard let bloodType = bloodType else {
            throw ValidationError.missingField(field: "血液型")
        }
        
        switch mode {
        case .create:
            let newUserProfile = UserProfile(
                name: name,
                birthday: birthday,
                bloodType: bloodType,
                introduction: introduction,
                icon: icon
            )
            
            return newUserProfile
            
        case .edit(let existingProfile):
            existingProfile.update(name: name,
                                   birthday: birthday,
                                   bloodType: bloodType,
                                   introduction: introduction,
                                   icon: icon)
            
            return existingProfile
        }
    }
    
    func loadIcon(from item: PhotosPickerItem?) async throws {
        // ユーザーが選択を解除した場合、アイコンをリセットして正常終了
        guard let item else {
            resetIcon()
            return
        }
        
        guard let data = try await item.loadTransferable(type: Data.self) else {
            throw IconLoadError.failedToReadItem
        }
        
        guard let image = UIImage(data: data) else {
            throw IconLoadError.dataCorrupted
        }
        
        self.icon = data
        self.iconImage = image
        
    }
    
    private func resetIcon() {
        self.icon = nil
        self.iconImage = nil
    }

}

enum ProfileFormMode {
    case create
    case edit(UserProfile)
}

enum ValidationError: Error {
    case missingField(field: String)
    
    var errorDescription: String? {
        switch self {
        case .missingField(field: let field):
            return "\(field)を入力してください。"
        }
    }
}

enum IconLoadError: LocalizedError {
    case failedToReadItem
    case dataCorrupted
    
    var errorDescription: String? {
        switch self {
        case .failedToReadItem:
            return "写真を読み込めませんでした。別の写真を選択してください。"
        case .dataCorrupted:
            return "選択した写真は壊れています。別の写真を選んでください。"
        }
    }
}
