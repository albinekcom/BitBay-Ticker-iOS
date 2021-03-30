import SwiftUI

struct TickersListEmptyListView: View {
    
    var body: some View {
        Text("Press + to add a ticker")
            .font(.subheadline)
            .foregroundColor(.tickersListEmptyListViewText)
    }
    
}

#if DEBUG
struct TickersListEmptyListView_Previews: PreviewProvider {
    
    static var previews: some View {
        TickersListEmptyListView()
    }
    
}
#endif
