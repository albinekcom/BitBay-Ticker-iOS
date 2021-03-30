import SwiftUI

struct TickerListRowView: View {
    
    let firstCurrency: String
    let secondCurrency: String
    let value: String
    
    var body: some View {
        HStack {
            CurrencyIconView(currencyName: firstCurrency)
            TitleView(firstCurrency: firstCurrency, secondCurrency: secondCurrency)
                .padding(.horizontal, 4)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.tickerListRowViewText)
            Image(systemName: "chevron.right")
                .font(.subheadline)
                .foregroundColor(.tickerListRowViewChevron)
        }
        .accessibility(label: Text("Ticker \(firstCurrency)\\\(secondCurrency)"))
        .accessibility(value: Text(value))
    }
    
}

#if DEBUG
struct TickerListRow_Previews: PreviewProvider {
    
    static var previews: some View {
        let firstCurrency = "BAT"
        let secondCurrency = "PLN"
        let value = "123.34 PLN"
        
        return Group {
            TickerListRowView(firstCurrency: firstCurrency, secondCurrency: secondCurrency, value: value)
                .previewLayout(.fixed(width: 400, height: 70))
                .environment(\.colorScheme, .light)
            TickerListRowView(firstCurrency: firstCurrency, secondCurrency: secondCurrency, value: value)
                .previewLayout(.fixed(width: 400, height: 70))
                .environment(\.colorScheme, .dark)
        }
    }
    
}
#endif
