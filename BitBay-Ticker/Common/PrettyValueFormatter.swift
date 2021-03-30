import Foundation

struct PrettyValueFormatter {
    
    private let numberFormatter: NumberFormatter
    
    init(locale: Locale = .current) {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.roundingMode = .halfUp
        numberFormatter.locale = locale
    }
    
    func prettyString(value: Double?, scale: Int?, currencyCode: String?) -> String {
        if let scale = scale {
            numberFormatter.minimumFractionDigits = scale
            numberFormatter.maximumFractionDigits = scale
        } else {
            numberFormatter.maximumFractionDigits = 10
        }
        
        var output: String
        
        if let value = value, let prettyValue = numberFormatter.string(from: NSNumber(value: value)) {
            output = prettyValue
        } else {
            output = "-"
        }
        
        if let currencyCode = currencyCode {
            output += " \(currencyCode)"
        }
        
        return output
    }
    
}
