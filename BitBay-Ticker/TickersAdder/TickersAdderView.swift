import SwiftUI

struct TickersAdderView: View {
    
    @ObservedObject var viewModel: TickersAdderViewModel
    
    var body: some View {
        List {
            TextField(LocalizedStringKey("Search"),
                      text: $viewModel.searchTerm)
                .modifier(ClearButton(text: $viewModel.searchTerm))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .buttonStyle(PlainButtonStyle())
            
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
        .environment(\.defaultMinListRowHeight, ApplicationConfiguration.Style.rowHeight)
    }
    
}
