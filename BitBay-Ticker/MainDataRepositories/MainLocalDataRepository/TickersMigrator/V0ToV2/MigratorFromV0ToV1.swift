import Foundation

extension TickerV0 {
    
    var migratedID: String {
        var nameString = name.rawValue.uppercased()
        
        nameString.insert("-", at: nameString.index(nameString.startIndex, offsetBy: name.baseCurrencyNameLength))
        
        return nameString
    }
    
}

struct MigratorFromV0ToV2: Migrator {
    
    var canBeMigrated: Bool {
        oldPlistData != nil
    }
    
    func loadMigratedTickers() -> [Ticker]? {
        guard
            let data = oldPlistData,
            let mainDictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any],
            let oldTickersDictionaries = mainDictionary[Key.tickers] as? [[String: Any]] else {
                return []
        }
        
        var oldTickers: [TickerV0] = []
        
        for oldTickersDictionary in oldTickersDictionaries {
            if let oldTickerNameString = oldTickersDictionary["name"] as? String, let oldTickerName = TickerV0.Name(rawValue: oldTickerNameString) {
                oldTickers.append(TickerV0(name: oldTickerName))
            }
        }
        
        UserDefaults.shared?.removeObject(forKey: Key.userDataPlistName)
        
        return oldTickers.map { TickerV1(id: $0.migratedID).convertToCurrentTicker() }
    }
    
    private struct Key {
        static let userDataPlistName = "user_data"
        static let tickers = "tickers"
    }
    
    private var oldPlistData: Data? {
        if let sharedUserDefaults = UserDefaults.shared,
           let data = sharedUserDefaults.value(forKey: Key.userDataPlistName) as? Data {
            return data
        } else {
            return nil
        }
    }
    
}
