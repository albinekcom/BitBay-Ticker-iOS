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
            guard let self = self else { return }
            
            let mainLocalDataRepositoryModelFromFile = self.mainLocalDataRepositoryModelFromFile
            
            DispatchQueue.main.async {
                completion(mainLocalDataRepositoryModelFromFile)
            }
        }
    }
    
    private var mainLocalDataRepositoryModelFromFile: MainLocalDataModel {
        if let localData = localData {
            return localData
        } else if let migratedData = migratedData {
            return migratedData
        } else {
            return DefaultMainLocalDataFetcherModel()
        }
    }
    
    private var localData: MainLocalDataModel? {
        if let mainLocalDataModelJSONValue = userDefaults?.object(forKey: ApplicationConfiguration.Storing.tempUserDataFileName) as? Data {
            return try? jsonDecoder.decode(MainLocalDataFetchedModel.self, from: mainLocalDataModelJSONValue)
        } else {
            return nil
        }
    }
    
    private var migratedData: MainLocalDataModel? {
        if let migratedTickers = oldTickersMigrator.migrateOldTickersToCurrentTickers() {
            return MainLocalDataFetchedModel(supportedTickers: [], currencies: [:], userTickers: migratedTickers)
        } else {
            return nil
        }
    }
    
}
