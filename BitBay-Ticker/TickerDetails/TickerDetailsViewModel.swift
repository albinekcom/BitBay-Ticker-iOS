import Foundation

final class TickerDetailsViewModel: ObservableObject {
    
    private let dataRepository: TickerDetailsDataRepositoryProtocol
    
    var tickerIdentifier: String {
        dataRepository.tickerIdentifier
    }
    
    private let prettyValueFormatter = PrettyValueFormatter()
    
    // MARK: - Initializers
    
    init(dataRepository: TickerDetailsDataRepositoryProtocol) {
        self.dataRepository = dataRepository
        self.dataRepository.delegate = self
        
        updateOutputProperties()
    }
    
    // MARK: - Output
    
    @Published private(set) var title: String = ""
    @Published private(set) var rowsData: [TickerDetailsRowData] = []
    
    // MARK: - Private
    
    private func updateOutputProperties() {
        updateTitle()
        updateRowsData()
    }
    
    private func updateTitle() {
        title = "\(dataRepository.model.firstCurrencyCode))\\\(dataRepository.model.secondCurrencyCode)"
    }
    
    private func updateRowsData() {
        rowsData = []
        
        rowsData.append(TickerDetailsRowData(title: "Name", value: dataRepository.model.firstCurrencyName))
        rowsData.append(TickerDetailsRowData(title: "Last", value: prettyValueFormatter.prettyString(value: dataRepository.model.rate,
                                                                                                     scale: dataRepository.model.secondCurrencyScale,
                                                                                                     currencyCode: nil)))
        rowsData.append(TickerDetailsRowData(title: "Previous", value: prettyValueFormatter.prettyString(value: dataRepository.model.previousRate,
                                                                                                         scale: dataRepository.model.secondCurrencyScale,
                                                                                                         currencyCode: nil)))
        rowsData.append(TickerDetailsRowData(title: "Maximum", value: prettyValueFormatter.prettyString(value: dataRepository.model.highestRate,
                                                                                                        scale: dataRepository.model.secondCurrencyScale,
                                                                                                        currencyCode: nil)))
        rowsData.append(TickerDetailsRowData(title: "Minimum", value: prettyValueFormatter.prettyString(value: dataRepository.model.lowestRate,
                                                                                                        scale: dataRepository.model.secondCurrencyScale,
                                                                                                        currencyCode: nil)))
        rowsData.append(TickerDetailsRowData(title: "Bid", value: prettyValueFormatter.prettyString(value: dataRepository.model.highestBid,
                                                                                                    scale: dataRepository.model.secondCurrencyScale,
                                                                                                    currencyCode: nil)))
        rowsData.append(TickerDetailsRowData(title: "Ask", value: prettyValueFormatter.prettyString(value: dataRepository.model.lowestAsk,
                                                                                                    scale: dataRepository.model.secondCurrencyScale,
                                                                                                    currencyCode: nil)))
        rowsData.append(TickerDetailsRowData(title: "Average", value: prettyValueFormatter.prettyString(value: dataRepository.model.average,
                                                                                                        scale: dataRepository.model.secondCurrencyScale,
                                                                                                        currencyCode: nil)))
        rowsData.append(TickerDetailsRowData(title: "Volume", value: prettyValueFormatter.prettyString(value: dataRepository.model.volume,
                                                                                                       scale: nil,
                                                                                                       currencyCode: nil)))
    }
    
}

extension TickerDetailsViewModel: TickerDetailsDataRepositoryDelegate {
    
    func didFetchNewModel(isTickerStillSupported: Bool) {
        //        if isTickerStillSupported == false { // NOTEc: Add informing about removed ticker
        //            dismiss(animated: true) // NOTE: Check if this works properly when this ticker is removed from supported tickers
        //        }
        
        updateOutputProperties()
    }
    
}
    
