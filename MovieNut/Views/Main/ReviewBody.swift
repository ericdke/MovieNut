import SwiftUI

struct ReviewBody: View {
    
    let movie: Movie
    @EnvironmentObject var tmdbViewModel: TMDBViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    @EnvironmentObject var pnutViewModel: PnutViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("YOUR REVIEW")
                    .font(uiViewModel.reviewHeaderCallToActionFont)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }

            HStack(alignment: .center, spacing: 0) {
                MNCosmosView(style: tmdbViewModel.selectedCandidate!.style,
                             size: uiViewModel.bigStarSize,
                             rating: $tmdbViewModel.rating)
                    .padding(.trailing)
                
                Spacer()
                
                Button(action: {
                    if pnutViewModel.isLoggedIn {
                        let mov = Movie(from: movie,
                                        rating: Float(tmdbViewModel.rating),
                                        review: tmdbViewModel.reviewText)
                        pnutViewModel.postReview(movie: mov)
                        uiViewModel.showCandidates = false
                    } else {
                        pnutViewModel.showLoginFromMain.toggle()
                    }
                }, label: {
                    Text("POST")
                        .fixedSize(horizontal: true, vertical: true)
                })
                    .primaryProminentStyle(tmdbViewModel.selectedCandidate!.style.color)
            }
        }
    }
}
