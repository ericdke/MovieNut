import SwiftUI

struct ReviewCellTitleGroup: View {
    
    let review: PnutRawOembedReview
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(review.title)
                .font(uiViewModel.cellMovieTitleFont)
                .fontWeight(.heavy)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
            
            if let orig = review.original_title {
                Text(orig)
                    .font(uiViewModel.cellBodyFont)
                    .fontWeight(.light)
            }
        }
    }
}
