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
        //ここでAPIを叩く
    }
    
}
