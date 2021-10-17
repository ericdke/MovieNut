import SwiftUI

struct ReplyTextEditor: View {
    
    @EnvironmentObject var pnutViewModel: PnutViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        ZStack {
            if pnutViewModel.writeReplyText.isEmpty {
                Text("Type your reply")
                    .foregroundColor(.gray)
                    .disabled(true)
            }
            // TODO: check max length
            TextEditor(text: $pnutViewModel.writeReplyText)
                .foregroundColor(.primary)
                .opacity(pnutViewModel.writeReplyText.isEmpty ? 0.1 : 1)

        }
        .cornerRadius(uiViewModel.posterCornerRadius)
        .shadow(color: .primary, radius: 1)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
