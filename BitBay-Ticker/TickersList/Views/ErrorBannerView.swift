import SwiftUI

struct ErrorBannerView: View {
    
    let text: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "xmark.octagon.fill")
                .foregroundColor(.errorBannerViewImage)
            Text(text)
                .foregroundColor(.errorBannerViewText)
            Spacer()
        }
        .padding()
        .background(Color.errorBannerViewBackground)
    }
    
}

#if DEBUG
struct ErrorBannerView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ErrorBannerView(text: "There is a problem with connection.")
                .previewLayout(.fixed(width: 400, height: 70))
                .environment(\.colorScheme, .light)
            ErrorBannerView(text: "There is a problem with connection.")
                .previewLayout(.fixed(width: 400, height: 70))
                .environment(\.colorScheme, .dark)
        }
    }
    
}
#endif
