
import Testing
import Foundation
import UIKit
@testable import YumemiPrefectureFortune

// MARK: - Mock Services

/// 占いAPIサービスのためのモック
struct MockFortuneAPIService: FortuneAPIServiceProtocol {
    var result: Result<FortuneResult, APIError>

    func fetchFortune(from request: FortuneRequestDTO) async throws -> FortuneResult {
        // 呼び出しを0.1秒遅延させて、非同期処理をシミュレート
        try await Task.sleep(nanoseconds: 100_000_000)
        return try result.get()
    }
}

/// 画像取得サービスのためのモック
struct MockImageService: ImageServiceProtocol {
    var fetchImageResult: Result<UIImage, Error>
    var searchImageResult: Result<UIImage, Error>

    // ダミーのUIImageインスタンスを生成
    static let dummyImage = UIImage(systemName: "star")!
    // ダミーのエラー
    struct DummyError: Error {}

    func fetchImage(from url: URL) async throws -> UIImage {
        return try fetchImageResult.get()
    }

    func searchImage(for query: String) async throws -> UIImage {
        return try searchImageResult.get()
    }
}

@Suite("FortuneDetailViewModel Tests")
struct FortuneDetailViewModelTests {

    var viewModel: FortuneDetailViewModel!
    var user: UserProfile!
    var mockAPIService: MockFortuneAPIService!
    var mockImageService: MockImageService!

    init() {
        // テストで使用するベースのユーザーを準備
        user = UserProfile(name: "テストユーザー", birthday: Date(), bloodType: .A, introduction: nil, icon: nil)
    }

    @Test("正常系: 占いと画像取得がすべて成功する")
    @MainActor
    mutating func testFetchAllSuccess() async throws {
        // --- 準備 ---
        let prefecture = Prefecture(name: "沖縄県", capital: "那覇市", citizenDay: nil, logoUrl: URL(string: "https://example.com")!, brief: "", hasCoastLine: true)
        let fortuneResult = FortuneResult(prefecture: prefecture)

        mockAPIService = MockFortuneAPIService(result: .success(fortuneResult))
        mockImageService = MockImageService(fetchImageResult: .success(MockImageService.dummyImage), searchImageResult: .success(MockImageService.dummyImage))

        // --- 実行 ---
        viewModel = FortuneDetailViewModel(user: user, apiService: mockAPIService, imageService: mockImageService)

        // --- 検証 ---
        // 初期化直後はローディング中のはず
        #expect(self.viewModel.isLoading == true)

        // 非同期処理の完了を待つ（APIのモックで0.1秒遅延させているため、それ以上待つ）
        try await Task.sleep(nanoseconds: 200_000_000)

        // 最終的な状態を検証
        #expect(self.viewModel.isLoading == false)
        #expect(self.viewModel.user.fortuneResult?.prefecture.name == "沖縄県")
        #expect(self.viewModel.logoImage != nil)
        #expect(self.viewModel.headerImage != nil)
    }

    @Test("異常系: 占いAPIがエラーを返す")
    @MainActor
    mutating func testFetchFortuneAPIFailure() async throws {
        // --- 準備 ---
        mockAPIService = MockFortuneAPIService(result: .failure(.networkError(URLError(.notConnectedToInternet))))
        mockImageService = MockImageService(fetchImageResult: .success(MockImageService.dummyImage), searchImageResult: .success(MockImageService.dummyImage))

        // --- 実行 ---
        viewModel = FortuneDetailViewModel(user: user, apiService: mockAPIService, imageService: mockImageService)

        // --- 検証 ---
        #expect(self.viewModel.isLoading == true)

        try await Task.sleep(nanoseconds: 200_000_000)

        #expect(self.viewModel.isLoading == false)
        #expect(self.viewModel.user.fortuneResult == nil) // 占い結果はnilのまま
        #expect(self.viewModel.logoImage == nil)      // 画像取得処理は実行されない
        #expect(self.viewModel.headerImage == nil)
    }

    @Test("異常系: ロゴ画像の取得に失敗する")
    @MainActor
    mutating func testFetchLogoImageFailure() async throws {
        // --- 準備 ---
        let prefecture = Prefecture(name: "沖縄県", capital: "那覇市", citizenDay: nil, logoUrl: URL(string: "https://example.com")!, brief: "", hasCoastLine: true)
        let fortuneResult = FortuneResult(prefecture: prefecture)

        mockAPIService = MockFortuneAPIService(result: .success(fortuneResult))
        // ロゴ画像取得のみ失敗させる
        mockImageService = MockImageService(fetchImageResult: .failure(MockImageService.DummyError()), searchImageResult: .success(MockImageService.dummyImage))

        // --- 実行 ---
        viewModel = FortuneDetailViewModel(user: user, apiService: mockAPIService, imageService: mockImageService)

        // --- 検証 ---
        try await Task.sleep(nanoseconds: 200_000_000)

        #expect(self.viewModel.isLoading == false)
        #expect(self.viewModel.user.fortuneResult != nil)
        #expect(self.viewModel.logoImage == nil) // ロゴ画像はnil
        #expect(self.viewModel.headerImage != nil) // ヘッダー画像は成功
    }
}
