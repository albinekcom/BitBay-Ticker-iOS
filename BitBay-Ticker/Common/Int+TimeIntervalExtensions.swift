import Foundation

extension Int {
    
    var seconds: TimeInterval { TimeInterval(self) }
    var minutes: TimeInterval { seconds * 60 }
    var hours: TimeInterval { minutes * 60 }
    var days: TimeInterval { hours * 24 }
    
}
