import SwiftUI

struct TickerDetailsRowView: View {
    
    let title: Text
    let value: Text
    
    var body: some View {
        HStack {
            title
                .font(.subheadline)
                .foregroundColor(.tickerDetailsRowViewTitleText)
            Spacer()
            value
                .font(.subheadline)
                .foregroundColor(.tickerDetailsRowViewValueText)
        }
        .accessibility(label: title)
        .accessibility(value: value)
    }
}

#if DEBUG
struct TickerDetailsRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            let title = Text("Test Title")
            let value = Text("123.45")
            
            TickerDetailsRowView(title: title, value: value)
                .colorScheme(.light)
            TickerDetailsRowView(title: title, value: value)
                .colorScheme(.dark)
        }
        .background(Color(UIColor.systemBackground))
        .previewLayout(.fixed(width: 400, height: 70))
    }
    
}
#endif
