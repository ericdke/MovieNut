import SwiftUI
import Kingfisher

struct MovieCellImageGroup: View {
    
    let movie: Movie
    let proxy: GeometryProxy
    @EnvironmentObject var uiViewModel: UIViewModel
    @State private var alreadyDownloadedBigImage = false
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                if uiViewModel.slowNetwork {
                    if alreadyDownloadedBigImage {
                        KFImage.url(URL(string: movie.imagePath!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(uiViewModel.posterCornerRadius)
                    } else {
                        if let url = movie.smallImagePath {
                            KFImage.url(URL(string: url)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(uiViewModel.posterCornerRadius)
                        } else {
                            PosterImageReplacement()
                        }
                    }
                } else {
                    if let url = movie.imagePath {
                        KFImage.url(URL(string: url)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(uiViewModel.posterCornerRadius)
                            .onAppear {
                                alreadyDownloadedBigImage = true
                            }
                    } else {
                        PosterImageReplacement()
                    }
                }
            }
            .frame(width: uiViewModel.posterWidth(with: proxy),
                   height: uiViewModel.posterHeight(with: proxy))
        }
    }
}
