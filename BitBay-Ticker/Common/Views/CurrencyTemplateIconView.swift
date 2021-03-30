import SwiftUI

struct CurrencyTemplateIconView: View {
    
    let letter: String
    let backgroundColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
            Text(letter)
                .font(.body)
                .foregroundColor(.currencyTemplateIconViewText)
        }
    }
    
}

#if DEBUG
struct CurrencyTemplateIconView_Previews: PreviewProvider {
    
    static var previews: some View {
        let letter = "A"
        let backgroundColor = Color.yellow
        
        return CurrencyTemplateIconView(letter: letter, backgroundColor: backgroundColor)
            .previewLayout(.fixed(width: 200, height: 200))
    }
    
}
#endif
