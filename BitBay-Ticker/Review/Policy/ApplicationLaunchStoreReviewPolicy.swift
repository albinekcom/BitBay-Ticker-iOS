final class ApplicationLaunchStoreReviewPolicy: StoreReviewPolicy {
    
    private let applicationLaunchCounter: ApplicationLaunchCounter
    private let displayReviewViewEveryXApplicationLaunchTimes: Int
    
    init(applicationLaunchCounter: ApplicationLaunchCounter = ApplicationLaunchCounter(),
         displayReviewViewEveryXApplicationLaunchTimes: Int = ApplicationConfiguration.User.displayReviewViewEveryXApplicationLaunchTimes) {
        self.applicationLaunchCounter = applicationLaunchCounter
        self.displayReviewViewEveryXApplicationLaunchTimes = displayReviewViewEveryXApplicationLaunchTimes
    }
    
    var shouldDisplayReview: Bool {
        applicationLaunchCounter.applicationLaunchCountSinceLastRequestedReview >= displayReviewViewEveryXApplicationLaunchTimes
    }
    
    func updatePolicyBeforeTryingToRequestReview() {
        applicationLaunchCounter.applicationLaunchCountSinceLastRequestedReview += 1
    }
    
    func updatePolicyAfterReviewWasRequested() {
        applicationLaunchCounter.applicationLaunchCountSinceLastRequestedReview = 0
    }
    
}
