final class ApplicationLaunchStoreReviewPolicy: StoreReviewPolicy {
    
    private var applicationLaunchCountSinceLastRequstingReview: Int = 1 // TODO: Improve this property by getting "applicationLaunchCount" from "UserDefaults" (use wrapping class for it)
    private let displayReviewViewEveryXApplicationLaunchTimes: Int
    
    init(displayReviewViewEveryXApplicationLaunchTimes: Int = ApplicationConfiguration.displayReviewViewEveryXApplicationLaunchTimes) {
        self.displayReviewViewEveryXApplicationLaunchTimes = displayReviewViewEveryXApplicationLaunchTimes
    }
    
    var shouldDisplayReview: Bool {
        applicationLaunchCountSinceLastRequstingReview >= displayReviewViewEveryXApplicationLaunchTimes
    }
    
    func updatePolicyBeforeRequestingReview() {
        // TODO: Increase / decrease "applicationLaunchCountSinceLastRequstingReview" property here
    }
    
    func updatePolicyAfterRequestingReview() {
        // TODO: Increase / decrease "applicationLaunchCountSinceLastRequstingReview" property here
    }
    
}

final class ApplicationLaunchCounter {
    
    var applicationLaunchCountSinceLastRequstingReview: Int {
        -1 // TODO: Use "UserDefaults" here
    }
    
}
