import SwiftUI

struct TickersListFilledListView: View {
    
    @ObservedObject var viewModel: TickersListViewModel
    
    var body: some View {
        List {
            if let tickerListError = viewModel.tickerListError {
                ErrorBannerView(text: "\("Error".localized): \(tickerListError.localizedDescription)")
            }
            ForEach(viewModel.rowsData) { rowData in
                Button(action: {
                    viewModel.selectRow(row: rowData)
                }) {
                    TickerListRowView(firstCurrency: rowData.firstCurrencyCode,
                                      secondCurrency: rowData.secondCurrencyCode,
                                      value: rowData.rateValue)
                }
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
        }
        .environment(\.defaultMinListRowHeight, ApplicationConfiguration.Style.rowHeight)
        .environment(\.editMode, .constant(viewModel.isEditing ? .active : .inactive))
        .animation(.default)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        viewModel.move(from: source, to: destination)
    }
    
    private func delete(at offsets: IndexSet) {
        guard let tickerToDeleteIndex = offsets.first else { return }
        
        viewModel.removeTicker(at: tickerToDeleteIndex)
    }
    
}

extension View {
    
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
    
}
