import SwiftUI

struct MovieClubView: View {
    
    @EnvironmentObject var pnutViewModel: PnutViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack(alignment: .center, spacing: 0) {
                    NavigationLink(destination: MovieClubThreadView(), isActive: $pnutViewModel.showThread) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: WritePostView(), isActive: $uiViewModel.showWritePost) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: WriteReplyView(style: pnutViewModel.selectedReplyTarget?.style ?? .black, proxy: proxy), isActive: $uiViewModel.showWriteReply) {
                        EmptyView()
                    }
                    
                    MovieClubHeader(proxy: proxy)

                    // TODO: display all images in messages
                    
                    MovieClubMainScroll(proxy: proxy)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onRotate { orientation in
            uiViewModel.orientation = orientation
        }
        .onAppear {
            if pnutViewModel.isLoggedIn == false {
                pnutViewModel.showLoginFromClub = true
            } else {
                pnutViewModel.startMainTimer()
            }
        }
        .onDisappear {
            pnutViewModel.stopMainTimer()
        }
    }
}
