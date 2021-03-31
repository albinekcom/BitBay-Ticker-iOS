import Firebase

final class LocalConsoleAnalytics: Analytics {
    
    static private(set) var basicLoggerLastLoggedName: String?
    static private(set) var basicLoggerLastLoggedParameters: [String: Any]?
    
    override class func logEvent(_ name: String, parameters: [String: Any]?) {
        basicLoggerLastLoggedName = name
        basicLoggerLastLoggedParameters = parameters

        let parametersString: String

        if let parameters = parameters {
            parametersString = " with parameters: \(parameters)"
        } else {
            parametersString = ""
        }

        print("[Console Analytics] Logged event: '\(name)'\(parametersString)")
    }
    
}
