// NOTE: This is temporary replacmenet for 3rd party Firebase, remove it after integrating FirebaseSDK

class FirebaseMock {
    
    static private(set) var lastLoggedName: String?
    static private(set) var lastLoggedParameters: [String: String]?
    
    class func logEvent(_ name: String, parameters: [String: String]?) {
        lastLoggedName = name
        lastLoggedParameters = parameters
        
        let parametersString: String
        
        if let parameters = parameters {
            parametersString = " with parameters: \(parameters)"
        } else {
            parametersString = ""
        }
        
        print("[Fake Firebase Analytics] Logged event: \"\(name)\"\(parametersString)")
    }
    
}
