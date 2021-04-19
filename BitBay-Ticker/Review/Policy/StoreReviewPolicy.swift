protocol StoreReviewPolicy {
    
    var shouldDisplayReview: Bool { get }
    
    func updatePolicyBeforeTryingToRequestReview()
    func updatePolicyAfterReviewWasRequested()
    
}
