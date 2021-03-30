import SwiftUI

struct TickersAdderEmptyRowView: View {
    
    var body: some View {
        Text("No results")
            .font(.subheadline)
            .foregroundColor(.tickersAdderEmptyRowViewText)
    }
    
}

#if DEBUG
struct TickersAdderEmptyRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        TickersAdderEmptyRowView()
    }
    
}
#endif
