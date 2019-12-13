import Combine

final class UserData: ObservableObject {
    
    @Published var tickers: [Ticker] = []
    
    init() {
        setUpFakeTickers()
    }
    
    private func setUpFakeTickers() {
        let firstCurrency1 = Currency(currency: "BTC", minimumOffer: 0.0001, scale: 3)
        let secondCurrency1 = Currency(currency: "PLN", minimumOffer: 0.01, scale: 2)
        let ticker1 = Ticker(id: "btc-pln", firstCurrency: firstCurrency1, secondCurrency: secondCurrency1, highestBid: 123, lowestAsk: 456, rate: 789, previousRate: 111.11)
        
        let firstCurrency2 = Currency(currency: "LTC", minimumOffer: 0.0001, scale: 3)
        let secondCurrency2 = Currency(currency: "PLN", minimumOffer: 0.01, scale: 2)
        let ticker2 = Ticker(id: "ltc-pln", firstCurrency: firstCurrency2, secondCurrency: secondCurrency2, highestBid: 123, lowestAsk: 456, rate: 789, previousRate: 222.22)
        
        let firstCurrency3 = Currency(currency: "BTC", minimumOffer: 0.0001, scale: 3)
        let secondCurrency3 = Currency(currency: "ETH", minimumOffer: 0.01, scale: 2)
        let ticker3 = Ticker(id: "btc-eth", firstCurrency: firstCurrency3, secondCurrency: secondCurrency3, highestBid: 123, lowestAsk: 456, rate: 789, previousRate: 333.33)
        
        tickers = []
        tickers.append(ticker1)
        tickers.append(ticker2)
        tickers.append(ticker3)
    }
    
}