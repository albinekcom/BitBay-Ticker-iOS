import Foundation

struct PrettyValueFormatter {
    
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.roundingMode = .down
        numberFormatter.locale = Locale.current
        
        return numberFormatter
    }()
    
    static func makePrettyString(value: Double?, scale: Int?, currency: String?) -> String {
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
        
        if let currency = currency {
            output += " \(currency)"
        }
        
        return output
    }
    
}
