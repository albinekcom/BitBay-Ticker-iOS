import Foundation

final class MainLocalDataSaver {
    
    private let userDefaults: UserDefaults?
    private let jsonEncoder: JSONEncoder
    
    init(userDefaults: UserDefaults? = UserDefaults.shared,
         jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.userDefaults = userDefaults
        self.jsonEncoder = jsonEncoder
    }
    
    func save(supportedTickers: [SupportedTicker], currencies: [String: Currency], userTickers: [Ticker]) {
        DispatchQueue.global(qos: .background).async {
            let mainLocalDataRepositoryModel = MainLocalDataFetchedModel(supportedTickers: supportedTickers,
                                                                         currencies: currencies,
                                                                         userTickers: userTickers)
            
            self.userDefaults?.set(try? self.jsonEncoder.encode(mainLocalDataRepositoryModel), forKey: ApplicationConfiguration.Storage.userDataKey)
        }
        
        print("MainLocalDataSaver.save()")
    }
    
}
