import UIKit

protocol ReviewController: AnyObject {
    
    var analyticsService: ReviewViewAnalyticsService? { get set }
    
    func requestReview(in windowScene: UIWindowScene?)
    
}
