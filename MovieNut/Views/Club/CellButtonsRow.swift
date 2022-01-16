import SwiftUI

struct CellButtonsRow: View {
    
    let message: PnutMessage
    let style: ContentStyle
    @EnvironmentObject var pnutViewModel: PnutViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    @State private var showDeleteAlert = false
    
    var body: some View {
        HStack {
            if pnutViewModel.threadId == nil {
                Button {
                    pnutViewModel.threadId = message.thread_id
                    pnutViewModel.showThread.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.circle")
                        .resizable()
                        .frame(width: uiViewModel.cellIconSize, height: uiViewModel.cellIconSize)
                        .foregroundColor(.white)
                }
            }
            
            if message.user?.id == pnutViewModel.getUserToken()?.user.id {
                Button {
                    showDeleteAlert.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: uiViewModel.cellIconSize, height: uiViewModel.cellIconSize)
                        .foregroundColor(.white)
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Delete this message?"),
                        message: Text("There is no undo."),
                        primaryButton: .destructive(Text("Delete")) {
                            pnutViewModel.deleteMessage(id: message.id)
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            
            Spacer()
            
            Button {
                pnutViewModel.selectedReplyTarget = SelectedReplyTarget(target: message, style: style)
                pnutViewModel.writeReplyText = ""
                if pnutViewModel.threadId == nil {
                    uiViewModel.showWriteReply.toggle()
                } else {
                    uiViewModel.showWriteReplyFromThread.toggle()
                }
            } label: {
                Image(systemName: "arrowshape.turn.up.left.circle")
                    .resizable()
                    .frame(width: uiViewModel.cellIconSize, height: uiViewModel.cellIconSize)
                    .foregroundColor(.white)
            }
        }
    }
}
