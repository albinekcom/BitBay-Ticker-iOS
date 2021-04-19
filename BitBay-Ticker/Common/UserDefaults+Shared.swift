import Foundation

extension UserDefaults {
    
    static let shared = UserDefaults(suiteName: ApplicationConfiguration.Storage.suitName)
    
}
