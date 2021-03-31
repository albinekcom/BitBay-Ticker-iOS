import SwiftUI

struct TickerDetailsView: View {
    
    @ObservedObject var viewModel: TickerDetailsViewModel
    
    var body: some View {
        List(viewModel.rowsData) { rowData in
            TickerDetailsRowView(title: Text(LocalizedStringKey(rowData.title)),
                                 value: Text(rowData.value))
        }
        .environment(\.defaultMinListRowHeight, ApplicationConfiguration.Style.rowHeight)
        .animation(.default)
    }
    
}

// MARK: - Previews

#if DEBUG
//struct TickerDetailsView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        TickerDetailsView(viewModel: TickerDetailsViewModel(dataRepository: <#TickerDetailsDataRepositoryProtocol#>))
//    }
//    
//}
#endif
