import SwiftUI

struct MovieClubThreadView: View {
    
    @EnvironmentObject var pnutViewModel: PnutViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    // TODO: unfinished
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 0) {
                NavigationLink(destination: WriteReplyView(style: pnutViewModel.selectedReplyTarget?.style ?? .black, proxy: proxy), isActive: $uiViewModel.showWriteReplyFromThread) {
                    EmptyView()
                }
                .navigationTitle("Conversation")
                .navigationBarTitleDisplayMode(.inline)
                
                MovieClubHeader(proxy: proxy)

                MovieClubThreadScroll(proxy: proxy)
            }
        }
        .onRotate { orientation in
            uiViewModel.orientation = orientation
        }
        .onAppear {
            if pnutViewModel.isLoggedIn == false {
                pnutViewModel.showLoginFromClub = true
            } else {
//                pnutViewModel.startThreadTimer()
            }
        }
        .onDisappear {
//            pnutViewModel.stopThreadTimer()
            pnutViewModel.threadId  = nil
        }
    }
    
}

struct MovieClubThreadView_Previews: PreviewProvider {
    static var previews: some View {
        MovieClubThreadView()
    }
}
