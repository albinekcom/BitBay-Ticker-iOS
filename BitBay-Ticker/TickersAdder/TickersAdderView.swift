import SwiftUI

struct TickersAdderView: View {
    
    @ObservedObject var viewModel: TickersAdderViewModel
    
    var body: some View {
        VStack {
            TextField(LocalizedStringKey("Search"), text: $viewModel.searchTerm)
                .modifier(ClearButton(text: $viewModel.searchTerm))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .buttonStyle(PlainButtonStyle())
                .padding([.top, .horizontal])
                .padding(.bottom, ApplicationConfiguration.Style.TickerAdderView.searchBottomPadding)
            
            Divider()
            
            List {
                if (viewModel.rowsData.isEmpty) {
                    TickersAdderEmptyRowView()
                } else {
                    ForEach(viewModel.rowsData) { rowData in
                        Button(action: {
                            viewModel.selectRow(row: rowData)
                        }) {
                            TickersAdderRowView(firstCurrency: rowData.firstCurrencyCode,
                                                secondCurrency: rowData.secondCurrencyCode)
                        }
                    }
                }
            }
        }
        .environment(\.defaultMinListRowHeight, ApplicationConfiguration.Style.rowHeight)
    }
    
}
