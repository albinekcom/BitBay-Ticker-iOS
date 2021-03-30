import SwiftUI

struct TickersAdderRowView: View {
    
    let firstCurrency: String
    let secondCurrency: String
    
    var body: some View {
        HStack {
            CurrencyIconView(currencyName: firstCurrency)
            TitleView(firstCurrency: firstCurrency, secondCurrency: secondCurrency)
                .padding(.horizontal, 4)
            Spacer()
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.tickersAdderRowViewImage)
                .font(.headline)
        }
        .accessibility(label: Text("Add ticker \(firstCurrency)\\\(secondCurrency)"))
    }
    
}

#if DEBUG
struct TickerAdderRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            Color(.black)
            TickersAdderRowView(firstCurrency: "BAT", secondCurrency: "PLN")
        }
        .previewLayout(.fixed(width: 400, height: 70))
        .environment(\.colorScheme, .dark)
    }
    
}
#endif
