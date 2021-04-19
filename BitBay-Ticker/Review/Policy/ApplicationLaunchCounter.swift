import Foundation

final class ApplicationLaunchCounter {
    
    private let userDefaults: UserDefaults?
    
    init(userDefaults: UserDefaults? = UserDefaults.shared) {
        self.userDefaults = userDefaults
    }
    
    var applicationLaunchCountSinceLastRequestedReview: Int {
        get {
            return userDefaults?.integer(forKey: ApplicationConfiguration.Storage.applicationLaunchCountSinceLastRequestedReviewKey) ?? 0
        }
        set {
            userDefaults?.set(newValue, forKey: ApplicationConfiguration.Storage.applicationLaunchCountSinceLastRequestedReviewKey)
        }
    }
    
}
