import Foundation

final class MainLocalDataFetcher {
    
    private let userDefaults: UserDefaults?
    private let jsonDecoder: JSONDecoder
    private let oldTickersMigrator: MigratorController
    
    init(userDefaults: UserDefaults? = UserDefaults.shared,
         jsonDecoder: JSONDecoder = JSONDecoder(),
         oldTickersMigrator: MigratorController = MigratorController()) {
        self.userDefaults = userDefaults
        self.jsonDecoder = jsonDecoder
        self.oldTickersMigrator = oldTickersMigrator
    }
    
    func loadAsynchronously(completion: @escaping (MainLocalDataModel) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let mainLocalDataRepositoryModelFromFile = self?.mainLocalDataRepositoryModelFromFile ?? MainLocalDataFetchedModel(supportedTickers: [], currencies: [], tickers: [])
            
            DispatchQueue.main.async {
                completion(mainLocalDataRepositoryModelFromFile)
            }
        }
    }
    
    func loadSynchronously() -> MainLocalDataModel {
        mainLocalDataRepositoryModelFromFile ?? MainLocalDataFetchedModel(supportedTickers: [], currencies: [], tickers: [])
    }
    
    private var mainLocalDataRepositoryModelFromFile: MainLocalDataModel? {
        let mainLocalDataRepositoryModelFromFile: MainLocalDataModel?
        
        guard let userData = userDefaults?.object(forKey: ApplicationConfiguration.Storing.tempUserDataFileName) else {
//            let migratedTickers = oldTickersMigrator.migrateOldTickersToCurrentTickers()
            
//            return MainLocalDataFetchedModel(supportedTickers: [], currencies: [], tickers: migratedTickers ?? [])
            return DefaultMainLocalDataFetcherModel() // NOTE: Remove it before shipping to the production
        }
        
        if let mainLocalDataModelJSONValue = userData as? Data {
            mainLocalDataRepositoryModelFromFile = try? jsonDecoder.decode(MainLocalDataFetchedModel.self, from: mainLocalDataModelJSONValue)
        } else {
            mainLocalDataRepositoryModelFromFile = nil
        }

        return mainLocalDataRepositoryModelFromFile
    }
    
}
