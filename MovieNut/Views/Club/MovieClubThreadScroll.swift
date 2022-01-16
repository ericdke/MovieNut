import SwiftUI

struct MovieClubThreadScroll: View {
    
    let proxy: GeometryProxy
    @EnvironmentObject var pnutViewModel: PnutViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(pnutViewModel.thread.indices, id: \.self) { index in
                    if let revs = pnutViewModel.thread[index].reviews, revs.isEmpty == false {
                        ReviewCell(message: pnutViewModel.thread[index],
                                   review: revs[0],
                                   style: ContentStyle(index),
                                   proxy: proxy)
                            .inColoredCell(color: Color(index))
                            .padding(.top)
                    } else {
                        MessageCell(message: pnutViewModel.thread[index],
                                    style: ContentStyle(index),
                                    proxy: proxy)
                            .inColoredCell(color: Color(index))
                            .padding(.top)
                    }
                }
            }
        }
    }
}
