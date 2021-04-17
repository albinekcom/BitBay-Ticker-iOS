import SwiftUI

struct TickersListView: View {
    
    @ObservedObject var viewModel: TickersListViewModel
    
    var body: some View {
        if viewModel.isInitialModelLoaded == false {
            TickersListInitialLoadingView() // NOTE: Edit and Plus button should be disabled
        } else if viewModel.rowsData.isEmpty {
            TickersListEmptyListView() // NOTE: Add displaying "TickersListInitialLoadingView"
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
