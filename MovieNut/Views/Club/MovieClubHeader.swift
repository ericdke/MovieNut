import SwiftUI

struct MovieClubHeader: View {
    
    let proxy: GeometryProxy
    @EnvironmentObject var pnutViewModel: PnutViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    // TODO: show reviews
    
    var body: some View {
        Group {
            NavigationLink(destination: LoginWebView(origin: .club),
                           isActive: $pnutViewModel.showLoginFromClub) {
                EmptyView()
            }
            .navigationTitle("Movie Club")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarLeading) {
//                    Button {
                //
//                    } label: {
//                        Image(systemName: "rectangle.and.text.magnifyingglass")
//                            .resizable()
//                    }
//                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        uiViewModel.showWritePost.toggle()
                    } label: {
                        Image(systemName: "doc.fill.badge.plus")
                            .resizable()
                    }
                }
            }
        }
    }
}
