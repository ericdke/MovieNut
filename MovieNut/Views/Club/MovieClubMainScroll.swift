import SwiftUI

struct MovieClubMainScroll: View {
    
    let proxy: GeometryProxy
    @EnvironmentObject var pnutViewModel: PnutViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(pnutViewModel.messages.indices, id: \.self) { index in
                    if let revs = pnutViewModel.messages[index].reviews, revs.isEmpty == false {
                        ReviewCell(message: pnutViewModel.messages[index],
                                   review: revs[0],
                                   style: ContentStyle(index),
                                   proxy: proxy)
                            .inColoredCell(color: Color(index))
                            .padding(.top)
                            .onAppear {
                                pnutViewModel.loadMoreMain(after: index)
                            }
                    } else {
                        MessageCell(message: pnutViewModel.messages[index],
                                    style: ContentStyle(index),
                                    proxy: proxy)
                            .inColoredCell(color: Color(index))
                            .padding(.top)
                            .onAppear {
                                pnutViewModel.loadMoreMain(after: index)
                            }
                    }
                }
            }
        }
    }
}
