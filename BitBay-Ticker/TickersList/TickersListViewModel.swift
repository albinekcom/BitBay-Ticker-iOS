import Foundation

protocol TickersListViewModelDelegate: AnyObject {
    
    func didSelectTicker(tickerIdentifier: String)
    func didRemoveTicker(tickerIdentifier: String)
    
}

enum TickersListError: Error {
    
    case fetchingError
    
}

final class TickersListViewModel: ObservableObject {
    
    private let dataRepository: TickersListDataRepositoryProtocol
    
    @Published var isEditing: Bool = false {
        didSet {
            refreshigResumeAutomaticRefreshingTickersPossible()
            
            isEditing ? pauseAutomaticRefreshingTickers() : resumeAutomaticRefreshingTickers()
        }
    }
    
    @Published private(set) var tickerListError: Error?
    
    var tickersAdderVisible: Bool = false {
        didSet {
            refreshigResumeAutomaticRefreshingTickersPossible()
            
            tickersAdderVisible ? pauseAutomaticRefreshingTickers() : resumeAutomaticRefreshingTickers()
        }
    }
    
    let title = "Tickers"
    private let prettyValueFormatter = PrettyValueFormatter()
    
    init(dataRepository: TickersListDataRepositoryProtocol) {
        self.dataRepository = dataRepository
        self.dataRepository.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tickerListError = TickersListError.fetchingError
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.tickerListError = nil
            }
        }
    }
    
    weak var delegate: TickersListViewModelDelegate?
    
    // MARK: - Other Input methods
    
    func selectRow(row: TickersListRowData) {
        delegate?.didSelectTicker(tickerIdentifier: row.id)
    }
    
    func resfreshModel() {
        dataRepository.resfreshModel()
    }
    
    var isResumeAutomaticRefreshingTickersPossible: Bool = true {
        didSet {
            dataRepository.isResumeAutomaticRefreshingTickersPossible = isResumeAutomaticRefreshingTickersPossible
        }
    }
    
    // MARK: - Output
    
    @Published private(set) var rowsData: [TickersListRowData] = []
    
    private func updateOutputProperties() {
        let rowsFromModel: [TickersListRowData] = dataRepository.model.tickers.map { ticker in
            let rateValue = prettyValueFormatter.prettyString(value: ticker.rate,
                                                                  scale: ticker.secondCurrencyScale,
                                                                  currencyCode: nil)
            
            return TickersListRowData(id: ticker.tickerIdentifier,
                                      iconName: ticker.firstCurrencyCode.uppercased(),
                                      firstCurrencyCode: ticker.firstCurrencyCode.uppercased(),
                                      secondCurrencyCode: ticker.secondCurrencyCode.uppercased(),
                                      rateValue: rateValue)
        }
        
        rowsData = rowsFromModel // NOTE: Use "diff" here and remove "DispatchQueue.main.asyncAfter" from the lines below
    }
    
    func removeTicker(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // NOTE: This is a hack for nice animation because "updateOutputProperties()" is invoked too fast and the deleting animation is not visible, use "diff in "updateOutputProperties"
            self.delegate?.didRemoveTicker(tickerIdentifier: self.dataRepository.model.tickers[index].tickerIdentifier)
            self.dataRepository.removeTicker(at: index)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        dataRepository.move(from: source, to: destination)
    }
    
    private func pauseAutomaticRefreshingTickers() {
        dataRepository.pauseAutomaticRefreshingTickers()
    }
    
    private func resumeAutomaticRefreshingTickers() {
        dataRepository.resumeAutomaticRefreshingTickers()
    }
    
    private func refreshigResumeAutomaticRefreshingTickersPossible() {
        isResumeAutomaticRefreshingTickersPossible = !tickersAdderVisible && !isEditing
    }
    
}

extension TickersListViewModel: TickersListDataRepositoryDelegate {
    
    func didFetchNewModel(error: Error?) {
        tickerListError = error
        
        updateOutputProperties()
    }
    
}
