import Foundation
import UIKit


final class FortuneDetailViewModel: ObservableObject {
    
    @Published var user: UserProfile
    @Published var logoImage: UIImage?
    @Published var headerImage: UIImage?
    @Published var isLoading: Bool
    
    private let apiService: FortuneAPIServiceProtocol
    private let imageService: ImageServiceProtocol
    
    init(user: UserProfile, apiService: FortuneAPIServiceProtocol = FortuneAPIService(), imageService: ImageServiceProtocol = ImageService()) {
        self.user = user
        self.isLoading = false
        self.apiService = apiService
        self.imageService = imageService
        fetchFortuneFromAPI(for: user)
    }
    
    func fetchFortuneFromAPI(for user: UserProfile) {
        isLoading = true
        
        let requestDTO = FortuneRequestDTO(user: self.user)
        
        Task {
            do {
                let result = try await apiService.fetchFortune(from: requestDTO)
                
                await MainActor.run {
                    self.user.updateFortune(with: result)
                    self.isLoading = false
                }
            } catch let apiError as APIError {
                // APIエラーをハンドリング
                await MainActor.run {
                    // TODO: エラー内容をアラートで表示するなどの処理
                    print("APIエラー: \\(apiError)")
                    self.isLoading = false
                }
            } catch {
                // その他の予期せぬエラー
                await MainActor.run {
                    print("不明なエラー: \\(error)")
                    self.isLoading = false
                }
            }
            
        }
    }
}
