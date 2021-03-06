import SwiftUI

struct TickerEmptyList: View {
    
    var body: some View {
        Text("Press + to add a ticker")
            .font(.subheadline)
            .foregroundColor(.primary)
    }
    
}

#if DEBUG
struct TickerEmptyList_Previews: PreviewProvider {
    
    static var previews: some View {
        TickerEmptyList()
    }
    
}
#endif
