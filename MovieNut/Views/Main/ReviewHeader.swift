import SwiftUI
import Kingfisher

struct ReviewHeader: View {
    
    let movie: Movie
    let proxy: GeometryProxy
    let style: ContentStyle
    @EnvironmentObject var uiViewModel: UIViewModel
    @State private var alreadyDownloadedBigImage = false
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {    
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
                                    .padding(.horizontal)
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
                                .padding(.horizontal)
                        }
                    }
                }
                .frame(width: uiViewModel.reviewPosterWidth(with: proxy),
                       height: uiViewModel.reviewPosterHeight(with: proxy))
            }
            .padding(.trailing, uiViewModel.isIpad ? 10 : 5)

            VStack(alignment: .leading, spacing: 0) {
                if let orig = movie.original_title {
                    Text(movie.title)
                        .font(uiViewModel.cellMovieTitleFont)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, uiViewModel.reviewHeadersBottomPadding)
                    
                    Text(orig)
                        .font(uiViewModel.cellBodyFont)
                        .fontWeight(.regular)
                        .italic()
                        .padding(.bottom)
                } else {
                    Text(movie.title)
                        .font(uiViewModel.cellMovieTitleFont)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                }
                
                if let date = movie.release_date {
                    HStack(alignment: .top, spacing: 0) {
                        HStack {
                            Text("Released")
                                .font(uiViewModel.reviewHeaderBodyFont)
                            
                            Spacer()
                        }
                        .frame(width: uiViewModel.reviewHeadersWidth(with: proxy))
                        
                        Text(date.prettyReleaseDate)
                            .font(uiViewModel.reviewHeaderBodyFont)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.bottom, uiViewModel.reviewHeadersBottomPadding)
                }
                
                HStack(alignment: .top, spacing: 0) {
                    HStack {
                        Text("Director")
                            .font(uiViewModel.reviewHeaderBodyFont)
                        
                        Spacer()
                    }
                    .frame(width: uiViewModel.reviewHeadersWidth(with: proxy))
                    
                    if movie.directorArray.isEmpty {
                        Text("Unknown")
                            .font(uiViewModel.reviewHeaderBodyFont)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(movie.directorArray.joined(separator: ", "))
                            .font(uiViewModel.reviewHeaderBodyFont)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.bottom, uiViewModel.reviewHeadersBottomPadding)
                
                HStack(alignment: .top, spacing: 0) {
                    HStack {
                        Text("Cast")
                            .font(uiViewModel.reviewHeaderBodyFont)
                        
                        Spacer()
                    }
                    .frame(width: uiViewModel.reviewHeadersWidth(with: proxy))
                    
                    if movie.castArray.isEmpty {
                        Text("Unknown")
                            .font(uiViewModel.reviewHeaderBodyFont)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(movie.castArray.joined(separator: ", "))
                            .font(uiViewModel.reviewHeaderBodyFont)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(.white)
        .inColoredCell(color: style.color)
    }
}
