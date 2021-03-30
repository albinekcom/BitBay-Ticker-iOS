import SwiftUI

struct TitleView: View {
    
    let firstCurrency: String
    let secondCurrency: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text(firstCurrency)
                .font(.headline)
                .foregroundColor(.titleViewFirstCurrencyText)
            Text("\\ \(secondCurrency)")
                .font(.footnote)
                .foregroundColor(.titleViewSecondCurrencyText)
        }
    }
    
}

#if DEBUG
struct TitleView_Previews: PreviewProvider {
    
    static var previews: some View {
        TitleView(firstCurrency: "BAT", secondCurrency: "PLN")
    }
    
}
#endif

