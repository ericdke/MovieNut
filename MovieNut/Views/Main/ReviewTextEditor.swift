import SwiftUI

struct ReviewTextEditor: View {
    
    @EnvironmentObject var tmdbViewModel: TMDBViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        ZStack {
            if tmdbViewModel.reviewText.isEmpty {
                Text("Type your review")
                    .foregroundColor(.gray)
                    .disabled(true)
            }
            // TODO: check max length
            TextEditor(text: $tmdbViewModel.reviewText)
                .foregroundColor(.primary)
                .opacity(tmdbViewModel.reviewText.isEmpty ? 0.1 : 1)

        }
        .cornerRadius(uiViewModel.posterCornerRadius)
        .shadow(color: .primary, radius: 1)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
