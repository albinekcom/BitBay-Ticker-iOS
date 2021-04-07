import Foundation

final class MainLocalDataSaver {
    
    private let userDefaults: UserDefaults?
    private let jsonEncoder: JSONEncoder
    
    init(userDefaults: UserDefaults? = UserDefaults.shared,
         jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.userDefaults = userDefaults
        self.jsonEncoder = jsonEncoder
    }
    
    func save(supportedTickers: [SupportedTicker], currencies: Set<Currency>, tickers: [Ticker]) {
        DispatchQueue.global(qos: .background).async {
            let mainLocalDataRepositoryModel = MainLocalDataFetchedModel(supportedTickers: supportedTickers,
                                                                         currencies: currencies,
                                                                         tickers: tickers)
            
            self.userDefaults?.set(try? self.jsonEncoder.encode(mainLocalDataRepositoryModel), forKey: ApplicationConfiguration.Storing.tempUserDataFileName)
        }
        
        print("MainLocalDataSaver.save()")
    }
    
}