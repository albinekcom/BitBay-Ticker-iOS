import SwiftUI

struct ClearButton: ViewModifier {
    
    @Binding var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content

            if text.isEmpty == false {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.clearButtonImage)
                }
                .padding(.trailing, 8)
            }
        }
    }
    
}
