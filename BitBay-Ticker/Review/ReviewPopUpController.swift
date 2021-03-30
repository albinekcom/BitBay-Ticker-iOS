import StoreKit

final class ReviewPopUpController { // NOTE: I think that it could be divided into ReviewPopUpPolicy and ReviewPopUpController
    
    private let applicationLaunchCounter: Int
    private let displayRatingPopUpEveryXApplicationLaunchTimes: Int
    private let analyticsService: RatingViewAnalyticsService?
    private let storeReviewController: SKStoreReviewController.Type
    
    init(applicationLaunchCounter: Int = 1,
         displayRatingPopUpEveryXApplicationLaunchTimes: Int = 1, // NOTE: Improve getting this parameters
         analyticsService: RatingViewAnalyticsService?,
         storeReviewController: SKStoreReviewController.Type = SKStoreReviewController.self) {
        self.applicationLaunchCounter = applicationLaunchCounter
        self.displayRatingPopUpEveryXApplicationLaunchTimes = displayRatingPopUpEveryXApplicationLaunchTimes
        self.analyticsService = analyticsService
        self.storeReviewController = storeReviewController
    }
    
    func displayReviewPopUpIfNeeded(in windowScene: UIWindowScene) {
        guard shouldDisplayReviewPopUp else { return }

        if #available(iOS 14.0, *) {
            storeReviewController.requestReview(in: windowScene)
        } else {
            storeReviewController.requestReview()
        }
        
        analyticsService?.trackRequstedRatingView()
    }
    
    private var shouldDisplayReviewPopUp: Bool {
        applicationLaunchCounter >= displayRatingPopUpEveryXApplicationLaunchTimes
    }
    
}
