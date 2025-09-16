import Testing
import Foundation
import SwiftData
@testable import YumemiPrefectureFortune

struct UserProfileTests {
    
    var modelContainer: ModelContainer = {
        do {
            let schema = Schema([UserProfile.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("テスト用のモデルコンテナ作成に失敗しました: \(error)")
        }
    }()

    static let testCases: [(introduction: String?, icon: Data?)] = [
        (introduction: "自己紹介です", icon: nil),
        (introduction: nil, icon: "icon_data".data(using: .utf8)),
        (introduction: "自己紹介とアイコンあり", icon: "icon_data".data(using: .utf8)),
        (introduction: nil, icon: nil)
    ]

    @Test("UserProfileが様々な引数で正しく初期化される", arguments: testCases)
    @MainActor
    func testInitialization(introduction: String?, icon: Data?) throws {
        // Given
        let context = modelContainer.mainContext
        let name = "テストユーザー"
        let birthday = Date()
        let bloodType = BloodType.A
        
        // When
        let user = UserProfile(name: name, birthday: birthday, bloodType: bloodType, introduction: introduction, icon: icon)
        context.insert(user)

        // Then
        #expect(user.name == name)
        #expect(user.birthday == birthday)
        #expect(user.bloodType == bloodType)
        #expect(user.introduction == introduction)
        #expect(user.icon == icon)
    }

    @Test("updateメソッドで様々な引数で正しく更新される", arguments: testCases)
    @MainActor
    func testUpdateProfile(introduction: String?, icon: Data?) throws {
        // Given
        let context = modelContainer.mainContext
        let user = UserProfile(name: "古い名前", birthday: Date(), bloodType: .B, introduction: "古い自己紹介", icon: "old_icon".data(using: .utf8))
        context.insert(user)
        
        let newName = "新しい名前"
        let newBirthday = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let newBloodType = BloodType.O
        
        // When
        user.update(name: newName, birthday: newBirthday, bloodType: newBloodType, introduction: introduction, icon: icon)
        
        // Then
        #expect(user.name == newName)
        #expect(user.birthday == newBirthday)
        #expect(user.bloodType == newBloodType)
        #expect(user.introduction == introduction)
        #expect(user.icon == icon)
    }
    
    @Test("updateFortuneメソッドで占い結果が正しく更新される")
    @MainActor
    func testUpdateFortune() throws {
        // Given
        let context = modelContainer.mainContext
        let user = UserProfile(name: "テスト", birthday: Date(), bloodType: .AB, introduction: nil, icon: nil)
        context.insert(user)
        
        // ダミーの占い結果を作成
        let prefecture = Prefecture(name: "沖縄県", capital: "那覇市", citizenDay: nil, logoUrl: URL(string: "https://example.com/okinawa.png")!, brief: "南国", hasCoastLine: true)
        let newFortune = FortuneResult(prefecture: prefecture)
        
        // When
        user.updateFortune(with: newFortune)
        
        // Then
        let resultPrefecture = try #require(user.fortuneResult?.prefecture)
        #expect(resultPrefecture.name == "沖縄県")
    }
}
