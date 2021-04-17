import XCTest
@testable import BitBay_Ticker

final class PrettyValueFormatterTests: XCTestCase {
    
    private var sut: PrettyValueFormatter!
    
    override func setUp() {
        super.setUp()
        
        sut = PrettyValueFormatter(locale: Locale(identifier: "en-US"))
    }
    
    func test_NilValue() {
        XCTAssertEqual(sut.prettyString(value: nil, scale: 2, currencyCode: nil), "-")
        XCTAssertEqual(sut.prettyString(value: nil, scale: 2, currencyCode: "PLN"), "- PLN")
    }
    
    func test_Scales() {
        XCTAssertEqual(sut.prettyString(value: 1234.5678, scale: nil, currencyCode: nil), "1,234.5678")
        XCTAssertEqual(sut.prettyString(value: 1234.5678, scale: 0, currencyCode: nil), "1,234")
        XCTAssertEqual(sut.prettyString(value: 1234.5678, scale: 1, currencyCode: nil), "1,234.5")
        XCTAssertEqual(sut.prettyString(value: 1234.5678, scale: 2, currencyCode: nil), "1,234.56")
        XCTAssertEqual(sut.prettyString(value: 1234.5678, scale: 3, currencyCode: nil), "1,234.567")
        XCTAssertEqual(sut.prettyString(value: 1234.5678, scale: 4, currencyCode: nil), "1,234.5678")
        XCTAssertEqual(sut.prettyString(value: 1234.5678, scale: 5, currencyCode: nil), "1,234.56780")
    }
    
    func test_AppendingCurrency() {
        XCTAssertEqual(sut.prettyString(value: 1234.5678, scale: nil, currencyCode: nil), "1,234.5678")
        XCTAssertEqual(sut.prettyString(value: 1234.5678, scale: nil, currencyCode: "BTC"), "1,234.5678 BTC")
    }
    
}
