import XCTest
@testable import BitBay_Ticker

final class TickerIdentifierComponentsTests: XCTestCase {
    
    func test_FirstCurrencyCode() {
        let tickerIdentifier1 = MockTickerIdentifierComponentsInstance(identifier: "BTC-PLN")
        XCTAssertEqual(tickerIdentifier1.firstCurrencyCode, "BTC")
        
        let tickerIdentifier2 = MockTickerIdentifierComponentsInstance(identifier: "BTCPLN")
        XCTAssertNil(tickerIdentifier2.firstCurrencyCode)
    }
    
    func test_SecondCurrencyCode() {
        let tickerIdentifier1 = MockTickerIdentifierComponentsInstance(identifier: "BTC-PLN")
        XCTAssertEqual(tickerIdentifier1.secondCurrencyCode, "PLN")
        
        let tickerIdentifier2 = MockTickerIdentifierComponentsInstance(identifier: "BTCPLN")
        XCTAssertNil(tickerIdentifier2.secondCurrencyCode)
    }

}

private struct MockTickerIdentifierComponentsInstance: TickerIdentifierComponents {
    
    let identifier: String
    
}
