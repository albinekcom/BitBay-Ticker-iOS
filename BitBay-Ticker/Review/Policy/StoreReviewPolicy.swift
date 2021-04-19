protocol StoreReviewPolicy {
    
    var shouldDisplayReview: Bool { get }
    
    func updatePolicyBeforeRequestingReview()
    func updatePolicyAfterRequestingReview()
    
}
