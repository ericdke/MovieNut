import SwiftUI

struct ReviewCellHeaderGroup: View {
    
    let review: PnutRawOembedReview
    let proxy: GeometryProxy
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ReviewCellTitleGroup(review: review)
                .padding(.bottom)
            
            if let date = review.release_date {
                HStack(alignment: .top, spacing: 0) {
                    ReviewCellRoleHeader(text: "Released")
                        .frame(width: uiViewModel.reviewHeadersWidth(with: proxy))
                    
                    Text(date.prettyReleaseDate)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                }
                .font(uiViewModel.reviewHeaderBodyFont)
                .padding(.bottom, 5)
            }
            
            HStack(alignment: .top, spacing: 0) {
                ReviewCellRoleHeader(text: "Director")
                    .frame(width: uiViewModel.reviewHeadersWidth(with: proxy))
                
                Text(review.director?.joined(separator: ", ") ?? "Unknown")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
            }
            .font(uiViewModel.reviewHeaderBodyFont)
            .padding(.bottom, 5)
            
            HStack(alignment: .top, spacing: 0) {
                ReviewCellRoleHeader(text: "Cast")
                    .frame(width: uiViewModel.reviewHeadersWidth(with: proxy))
                
                Text(review.cast?.joined(separator: ", ") ?? "Unknown")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
            }
            .font(uiViewModel.reviewHeaderBodyFont)
            .padding(.bottom)
        }
    }
}
