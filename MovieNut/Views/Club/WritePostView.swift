import SwiftUI

struct WritePostView: View {
    
    @EnvironmentObject var pnutViewModel: PnutViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("This is a simple post for the Movie Club channel. To write a movie review, please use the Review tab instead.")
                    .padding()
                
                Button(action: {
                    if pnutViewModel.writePostText.isBlank {
                        pnutViewModel.errorMessage = "You cannot post blank text."
                        pnutViewModel.showAlert.toggle()
                    } else {
                        // TODO: wait + success banner
                        // TODO: check max length
                        pnutViewModel.postMessage()
                        uiViewModel.showWritePost = false
                    }
                }, label: {
                    Text("POST")
                        .fixedSize(horizontal: true, vertical: true)
                })
                    .primaryProminentStyle()
                    .padding([.bottom, .trailing])
            }
            .navigationTitle("Write a post")
            .navigationBarTitleDisplayMode(.inline)

            ZStack {
                if pnutViewModel.writePostText.isEmpty {
                    Text("Type your post")
                        .foregroundColor(.gray)
                        .disabled(true)
                }
                
                TextEditor(text: $pnutViewModel.writePostText)
                    .foregroundColor(.primary)
                    .opacity(pnutViewModel.writePostText.isEmpty ? 0.1 : 1)

            }
            .cornerRadius(uiViewModel.posterCornerRadius)
            .shadow(color: .primary, radius: 1)
            .padding([.horizontal, .bottom])
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}
