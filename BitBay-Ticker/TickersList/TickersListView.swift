import SwiftUI

struct TickersListView: View {
    
    @ObservedObject var viewModel: TickersListViewModel
    
    var body: some View {
        if viewModel.rowsData.isEmpty {
            TickersListEmptyListView()
        } else {
            TickersListFilledListView(viewModel: viewModel)
        }
    }
    
}

// MARK: - Previews

#if DEBUG
//struct TickersListView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        TickerDetailsView(viewModel: TickerDetailsViewModel())
//    }
//
//}
#endif
