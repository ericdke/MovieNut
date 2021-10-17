import SwiftUI

struct MovieCell: View {
    
    let movie: Movie
    let proxy: GeometryProxy
    let style: ContentStyle
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                MovieCellImageGroup(movie: movie, proxy: proxy)

                MovieCellMetaGroup(movie: movie)
                    .padding(.leading)
                
                Spacer()
            }
            
            HStack {
                if let plot = movie.overview {
                    Text(plot)
                        .font(uiViewModel.cellBodyFont)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(uiViewModel.cellMaxLines)
                        .truncationMode(.tail)
                        .padding(.top)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .inColoredCell(cornerRadius: 12, color: style.color)
    }
}
