import Foundation
import SwiftData


@Model
final class UserProfile {
    
    // MARK: - Properties
    
    /// 本来 id は let にすべきだが SwiftData (on Swift 6)の都合上varにしなければならない
    /// そのため private(set) var 修飾子にしてファイル外からの変更を防ぐ
    @Attribute(.unique) private(set) var id: UUID
    
    /// private(set) var 修飾子により専用メソッドを通じてのみ更新するようにする
    private(set) var name: String
    private(set) var birthday: Date
    private(set) var bloodType: BloodType
    private(set) var introduction: String?
    private(set) var icon: Data?
    
    @Transient var fortuneResult: FortuneResult?
    
    // MARK: - Initializer

    init(id: UUID,
         name: String,
         birthday: Date,
         bloodType: BloodType,
         introduction: String? = nil,
         icon: Data? = nil,
         fortuneResult: FortuneResult? = nil) {
        
        self.id = id
        self.name = name
        self.birthday = birthday
        self.bloodType = bloodType
        self.introduction = introduction
        self.icon = icon
        self.fortuneResult = fortuneResult
    }
    
    // MARK: - Mutating Methods
    
    public func update(name: String,
                       birthday: Date,
                       bloodType: BloodType,
                       introduction: String?,
                       icon: Data?) {
        
        self.name = name
        self.birthday = birthday
        self.bloodType = bloodType
        self.introduction = introduction
        self.icon = icon
    }
    
    public func updateFortune(with result: FortuneResult?) {
        self.fortuneResult = result
    }

}
