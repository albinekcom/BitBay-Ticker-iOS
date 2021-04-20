import UIKit

struct ApplicationConfiguration {
    
    struct Style {
        
        static let rowHeight: CGFloat = 64
        
        struct TickerAdderView {
            
            static let searchBottomPadding: CGFloat = 8
            
        }
        
    }
    
    struct Storage {
        
        static let suitName = "group.com.albinek.ios.BitBay-Ticker.shared.defaults"
        
        static let userDataKey = "user_data_v3"
        static let applicationLaunchCountSinceLastRequestedReviewKey = "application_launch_count_since_last_requested_review"
        static let lastSupportedTickersSuccessfulRefreshDateKey = "last_supported_tickers_successful_refresh_date"
        
    }
    
    struct User {
        
        static let timeSpanBetweenAutomaticRefreshingTicker = 15.seconds
        static let minimumTimeSpanBetweenSupportedTickersRefreshes = 3.days
        
        static let displayReviewViewEveryXApplicationLaunchTimes = 10
        
    }
    
}
