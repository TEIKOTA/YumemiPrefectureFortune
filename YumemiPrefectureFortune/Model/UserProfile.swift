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
    
    private(set) var lastAccessedAt: Date?
    
    @Transient var fortuneResult: FortuneResult?
    
    // MARK: - Initializer
    /// `id`の引数はテストなどで明示的に指定する場合を除き基本的に省略する
    init(id: UUID = UUID(),
         name: String,
         birthday: Date,
         bloodType: BloodType,
         introduction: String?,
         icon: Data?) {
        
        self.id = id
        self.name = name
        self.birthday = birthday
        self.bloodType = bloodType
        self.introduction = introduction
        self.icon = icon
        
        self.lastAccessedAt = Date()
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
        self.lastAccessedAt = Date()
    }
}
