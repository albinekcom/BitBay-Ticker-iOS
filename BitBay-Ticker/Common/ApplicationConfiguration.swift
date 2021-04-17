import UIKit

struct ApplicationConfiguration {
    
    struct Style {
        
        static let rowHeight: CGFloat = 64
        
    }
    
    struct Storing {
        
        static let sharedDefaultsIdentifier: String = "group.com.albinek.ios.BitBay-Ticker.shared.defaults"
        static let userDataFileName: String = "user_data_v3"
        static let tempUserDataFileName: String = "tem_user_data_v3" // NOTE: Remove it after finishing implementation
        static let applicationLaunchCounterKey: String = "application_launch_counter"
        static let lastRefreshingSupportedTickersDateKey: String = "last_refreshing_supported_tickers_date"
        
    }
    
    struct UserData {
          
          static let timeSpanBetweenAutomaticRefreshingTicker: TimeInterval = 15.seconds
          static let minimumTimeSpanBetweenTickerIndentifiersRefreshes: TimeInterval = 3.days
          
      }
    
    static let displayRatingPopUpEveryXApplicationLaunchTimes: Int = 10
    
}
