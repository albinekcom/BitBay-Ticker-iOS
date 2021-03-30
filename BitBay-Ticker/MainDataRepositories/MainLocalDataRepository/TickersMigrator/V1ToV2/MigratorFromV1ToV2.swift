import Foundation

final class MigratorFromV1ToV2: Migrator {
    
    func loadMigratedTickers() -> [Ticker]? {
        guard let tickersV1 = tickersFromFile else { return nil }
        
        return tickersV1.map { $0.convertToCurrentTicker() }
    }
    
    private let key: String = "user_data_tickers_v1"
    
    private var valuesToMigrate: Data?
    
    var canBeMigrated: Bool {
        if valuesToMigrate == nil {
            valuesToMigrate = UserDefaults.shared?.object(forKey: key) as? Data
        }
        
        if let _ = valuesToMigrate {
            return true
        } else {
            return false
        }
    }
    
    private var tickersFromFile: [TickerV1]? {
        let tickersFromFile: [TickerV1]?
        
        if let decodedTickersFromFile = valuesToMigrate {
            tickersFromFile = try? JSONDecoder().decode([TickerV1].self, from: decodedTickersFromFile)
        } else {
            tickersFromFile = nil
        }
        
        return tickersFromFile
    }
    
}
