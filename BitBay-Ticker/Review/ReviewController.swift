protocol ReviewController: AnyObject, StoreReviewController {
    
    var analyticsService: ReviewViewAnalyticsService? { get set }
    
}
