import Foundation
import UIKit


final class FortuneDetailViewModel: ObservableObject {
    
    @Published var user: UserProfile
    @Published var logoImage: UIImage?
    @Published var headerImage: UIImage?
    @Published var isLoading: Bool
    
    init(user: UserProfile) {
        self.user = user
        self.isLoading = false
        fetchFortuneFromAPI(for: user)
    }
    
    func fetchFortuneFromAPI(for user: UserProfile) {
        isLoading = true
        //ここでAPIを叩く
    }
    
}
