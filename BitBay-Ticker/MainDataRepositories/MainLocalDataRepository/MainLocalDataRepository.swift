final class MainLocalDataRepository {
    
    private let mainLocalDataSaver: MainLocalDataSaver
    private let mainLocalDataFetcher: MainLocalDataFetcher
    
    init(mainLocalDataSaver: MainLocalDataSaver = MainLocalDataSaver(),
         mainLocalDataFetcher: MainLocalDataFetcher = MainLocalDataFetcher()) {
        self.mainLocalDataSaver = mainLocalDataSaver
        self.mainLocalDataFetcher = mainLocalDataFetcher
    }
    
    func load(completion: @escaping (MainLocalDataModel) -> Void) {
        mainLocalDataFetcher.loadAsynchronously() { mainLocalDataModel in
            completion(mainLocalDataModel)
        }
    }
    
    func save(supportedTickers: [SupportedTicker], currencies: Set<Currency>, userTickers: [Ticker]) {
//        mainLocalDataSaver.save(supportedTickers: supportedTickers, currencies: currencies, userTickers: userTickers) // NOTE: Uncomment it
    }
    
}
