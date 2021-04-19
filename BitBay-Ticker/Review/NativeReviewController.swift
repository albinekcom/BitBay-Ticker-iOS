import UIKit

final class NativeReviewController: ReviewController {
    
    weak var analyticsService: ReviewViewAnalyticsService?
    
    private let storeReviewPolicy: StoreReviewPolicy
    private let storeReviewController: StoreReviewController
    
    init(storeReviewPolicy: StoreReviewPolicy = ApplicationLaunchStoreReviewPolicy(),
         storeReviewController: StoreReviewController = NativeStoreReviewController()) {
        self.storeReviewPolicy = storeReviewPolicy
        self.storeReviewController = storeReviewController
    }
    
    func requestReview(in windowScene: UIWindowScene?) {
        storeReviewPolicy.updatePolicyBeforeRequestingReview()
        
        guard storeReviewPolicy.shouldDisplayReview else { return }
        
        storeReviewPolicy.updatePolicyAfterRequestingReview()
        
        storeReviewController.requestReview(in: windowScene)
        
        analyticsService?.trackRequstedReviewView()
    }
    
}
