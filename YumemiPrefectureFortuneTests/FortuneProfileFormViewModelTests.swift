import Testing
@testable import YumemiPrefectureFortune
import Foundation

@Suite("FortuneProfileFormViewModel Tests")
struct FortuneProfileFormViewModelTests {
    
    // ベースとなるユーザー情報を生成するプライベートメソッド
    private func makeTestUser() -> UserProfile {
        UserProfile(
            name: "テストユーザー",
            birthday: Date(timeIntervalSince1970: 0),
            bloodType: .A,
            introduction: "よろしく",
            icon: nil
        )
    }

    @Test("新規作成モードでの初期化")
    func testInitForCreateMode() {
        let viewModel = FortuneProfileFormViewModel(user: nil)
        
        #expect(viewModel.name == nil)
        #expect(viewModel.birthday == nil)
        #expect(viewModel.bloodType == nil)
        #expect(viewModel.introduction == nil)
        #expect(viewModel.iconImage == nil)
        
        switch viewModel.mode {
        case .create:
            // 成功
            break
        case .edit:
            Issue.record("新規作成モードのはずが、編集モードになっている")
        }
    }
    
    @Test("編集モードでの初期化")
    func testInitForEditMode() {
        // テストの最初に一度だけインスタンスを生成
        let user = makeTestUser()
        let viewModel = FortuneProfileFormViewModel(user: user)
        
        #expect(viewModel.name == "テストユーザー")
        #expect(viewModel.birthday == Date(timeIntervalSince1970: 0))
        #expect(viewModel.bloodType == .A)
        #expect(viewModel.introduction == "よろしく")
        
        switch viewModel.mode {
        case .create:
            Issue.record("編集モードのはずが、新規作成モードになっている")
        case .edit(let editingUser):
            // 同じインスタンスのIDと比較する
            #expect(editingUser.id == user.id)
        }
    }
    
    @Test("保存時のバリデーション - 名前なし")
    func testSaveValidationForMissingName() {
        let viewModel = FortuneProfileFormViewModel(user: nil)
        viewModel.birthday = Date()
        viewModel.bloodType = .B
        
        #expect(throws: ValidationError.self) {
            _ = try viewModel.save()
        }
    }
    
    @Test("保存時のバリデーション - 誕生日なし")
    func testSaveValidationForMissingBirthday() {
        let viewModel = FortuneProfileFormViewModel(user: nil)
        viewModel.name = "テスト"
        viewModel.bloodType = .B
        
        #expect(throws: ValidationError.self) {
            _ = try viewModel.save()
        }
    }
    
    @Test("保存時のバリデーション - 血液型なし")
    func testSaveValidationForMissingBloodType() {
        let viewModel = FortuneProfileFormViewModel(user: nil)
        viewModel.name = "テスト"
        viewModel.birthday = Date()
        
        #expect(throws: ValidationError.self) {
            _ = try viewModel.save()
        }
    }
    
    @Test("新規ユーザーの保存")
    func testSaveForNewUser() throws {
        let viewModel = FortuneProfileFormViewModel(user: nil)
        viewModel.name = "新しいユーザー"
        viewModel.birthday = Date()
        viewModel.bloodType = .O
        viewModel.introduction = "はじめまして"
        
        let newUser = try viewModel.save()
        
        #expect(newUser.name == "新しいユーザー")
        #expect(newUser.bloodType == .O)
        #expect(newUser.introduction == "はじめまして")
    }
    
    @Test("既存ユーザーの更新")
    func testSaveForExistingUser() throws {
        // テストの最初に一度だけインスタンスを生成
        let originalUser = makeTestUser()
        let viewModel = FortuneProfileFormViewModel(user: originalUser)
        
        viewModel.name = "更新されたユーザー"
        viewModel.introduction = "更新しました"
        
        let updatedUser = try viewModel.save()
        
        // 同じインスタンスのIDと比較する
        #expect(updatedUser.id == originalUser.id)
        #expect(updatedUser.name == "更新されたユーザー")
        #expect(updatedUser.introduction == "更新しました")
    }
}
