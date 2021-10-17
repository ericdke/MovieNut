import SwiftUI

struct WriteReplyView: View {
    
    @EnvironmentObject var pnutViewModel: PnutViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    let style: ContentStyle
    let proxy: GeometryProxy
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Spacer()
                
                Button(action: {
                    // TODO: check max length
                    if pnutViewModel.writeReplyText.isBlank {
                        pnutViewModel.errorMessage = "You cannot post blank text."
                        pnutViewModel.showAlert.toggle()
                    } else {
                        // TODO: wait + success banner
                        pnutViewModel.postReply()
                        pnutViewModel.selectedReplyTarget = nil
                        uiViewModel.showWriteReply.toggle()
                    }
                }, label: {
                    Text("POST")
                        .fixedSize(horizontal: true, vertical: true)
                })
                    .primaryProminentStyle()
                    .padding([.bottom, .trailing])
            }
            .navigationTitle("Write a reply")
            .navigationBarTitleDisplayMode(.inline)

            ReplyTextEditor()
                .padding([.horizontal, .bottom])
            
            Text("Replying to:")
                
            if let rep = pnutViewModel.selectedReplyTarget {
                MessageCell(message: rep.target,
                            isReplying: true,
                            style: style,
                            proxy: proxy)
                    .inColoredCell(color: style.color)
                    .padding()
            } else {
                Text("[Unknown]")
                    .padding()
            }
        }
    }
}
