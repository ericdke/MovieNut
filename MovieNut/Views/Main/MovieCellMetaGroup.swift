import SwiftUI

struct MovieCellMetaGroup: View {
    
    let movie: Movie
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let orig = movie.original_title, orig != movie.title {
                Text(movie.title)
                    .font(uiViewModel.cellMovieTitleFont)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, uiViewModel.reviewHeadersBottomPadding)
                
                Text(orig)
                    .font(uiViewModel.cellBodyFont)
                    .fontWeight(.regular)
                    .italic()
                    .padding(.bottom, uiViewModel.textBottomPadding)
            } else {
                Text(movie.title)
                    .font(uiViewModel.cellMovieTitleFont)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, uiViewModel.textBottomPadding)
            }
            
            if let date = movie.release_date, date.isBlank == false {
                Text("Released: \(date.prettyReleaseDate)")
            }

            if movie.director.isBlank == false {
                Text(movie.director)
                    .multilineTextAlignment(.leading)
            }
            
            if movie.cast.isBlank == false {
                Text(movie.cast)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, uiViewModel.textBottomPadding)
            }
        }
        .font(uiViewModel.cellBodyFont)
        .foregroundColor(.white)
    }
}
