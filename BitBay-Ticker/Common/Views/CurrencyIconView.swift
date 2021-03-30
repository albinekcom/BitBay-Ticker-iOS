import SwiftUI

struct CurrencyIconView: View {
    
    let currencyName: String
    
    static let size: CGFloat = 28
    
    var body: some View {
        Group {
            if UIImage(named: currencyName) != nil {
                Image(uiImage: UIImage(named: currencyName)!)
                    .resizable()
            } else if currencyName.first != nil {
                CurrencyTemplateIconView(letter: String(currencyName.first!), backgroundColor: currencyName.color)
            } else {
                Text("")
            }
        }
        .frame(width: Self.size, height: Self.size)
    }
    
}

#if DEBUG
struct CurrencyIconView_Previews: PreviewProvider {
    
    static var previews: some View {
        let currencyName = "BTC"
        
        return CurrencyIconView(currencyName: currencyName)
            .previewLayout(.fixed(width: 200, height: 200))
    }
    
}
#endif

extension String {
    
    var color: Color {
        var total = 0
        
        for u in unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 200)
        let red = CGFloat(drand48())
        
        srand48(total)
        let green = CGFloat(drand48())
        
        srand48(total / 200)
        let blue = CGFloat(drand48())
        
        return Color(UIColor(red: red, green: green, blue: blue, alpha: 1))
    }
    
}
