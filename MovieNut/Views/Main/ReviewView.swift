import SwiftUI

struct ReviewView: View {
    
    let proxy: GeometryProxy
    @EnvironmentObject var uiViewModel: UIViewModel
    @EnvironmentObject var pnutViewModel: PnutViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink(destination: LoginWebView(origin: .main),
                           isActive: $pnutViewModel.showLoginFromMain) {
                EmptyView()
            }
            
            if uiViewModel.isPortrait {
                VerticalReviewView(proxy: proxy)
            } else {
                HorizontalReviewView(proxy: proxy)
            }

            Spacer()
        }
        .padding()
    }
}
