import SwiftUI
import Kingfisher

struct ReviewCellImageGroup: View {
    
    @EnvironmentObject var uiViewModel: UIViewModel
    let review: PnutRawOembedReview
    @Binding var alreadyDownloadedBigImage: Bool
    
    var body: some View {
        Group {
            if uiViewModel.slowNetwork {
                if alreadyDownloadedBigImage {
                    KFImage.url(URL(string: review.poster_url!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(uiViewModel.posterCornerRadius)
                } else {
                    if let url = review.smallPosterURL {
                        KFImage.url(URL(string: url)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(uiViewModel.posterCornerRadius)
                    } else {
                        PosterImageReplacement()
                            .padding(.horizontal)
                    }
                }
            } else {
                if let url = review.poster_url {
                    KFImage.url(URL(string: url)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(uiViewModel.posterCornerRadius)
                        .onAppear {
                            alreadyDownloadedBigImage = true
                        }
                } else {
                    PosterImageReplacement()
                        .padding(.horizontal)
                }
            }
        }
    }
}
