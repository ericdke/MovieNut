import SwiftUI

struct ReviewCell: View {

    @EnvironmentObject var uiViewModel: UIViewModel
    let message: PnutMessage
    let review: PnutRawOembedReview
    var isReplying: Bool = false
    let style: ContentStyle
    let proxy: GeometryProxy
    @State private var alreadyDownloadedBigImage = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PnutCellHeader(message: message)
                .cellHeaderStyled()
                .padding(.bottom)
            
            HStack(alignment: .top) {
                VStack {
                    ReviewCellImageGroup(review: review, alreadyDownloadedBigImage: $alreadyDownloadedBigImage)
                        .frame(width: uiViewModel.reviewPosterWidth(with: proxy),
                           height: uiViewModel.reviewPosterHeight(with: proxy))
                    
                    Text("\(review.rating.toPrettyString())/5")
                        .font(uiViewModel.cellRatingFont)
                        .fontWeight(.heavy)
                        .padding(.bottom)
                }
                .padding(.trailing, uiViewModel.isIpad ? 10 : 5)

                ReviewCellHeaderGroup(review: review, proxy: proxy)
                
                if !uiViewModel.isPortrait {
                    Spacer()
                }
            }
            .padding(.top)
            
            MNCosmosView(style: .white,
                         size: uiViewModel.smallStarSize,
                         enabled: false,
                         rating: .constant(Double(review.rating)))
                .padding(.vertical)
                .centeredInSpacedHStack()
            
            Text(review.review)
                .font(uiViewModel.cellBodyFont)
                .fontWeight(.medium)
                .padding(.vertical)
            
            if let imdb = review.imdb_url {
                Link("More on IMDb", destination: URL(string: imdb)!)
                    .padding(8)
                    .background(Color.black.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .centeredInSpacedHStack()
                    .padding(.top)
            }
            
            if isReplying == false {
                CellButtonsRow(message: message, style: style)
                    .padding(.top)
            }
        }
        .foregroundColor(.white)
    }
}
