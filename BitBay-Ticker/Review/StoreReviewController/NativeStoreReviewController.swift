import StoreKit

struct NativeStoreReviewController: StoreReviewController {
    
    private let systemStoreReviewController: SKStoreReviewController.Type
    
    init(systemStoreReviewController: SKStoreReviewController.Type = SKStoreReviewController.self) {
        self.systemStoreReviewController = systemStoreReviewController
    }
    
    func requestReview(in windowScene: UIWindowScene?) {
        if #available(iOS 14.0, *), let windowScene = windowScene {
            systemStoreReviewController.requestReview(in: windowScene)
        } else {
            systemStoreReviewController.requestReview()
        }
    }
    
}
