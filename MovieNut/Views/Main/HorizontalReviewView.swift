import SwiftUI

struct HorizontalReviewView: View {

    let proxy: GeometryProxy
    @EnvironmentObject var tmdbViewModel: TMDBViewModel
    
    var movie: Movie {
        tmdbViewModel.selectedCandidate!.candidate
    }
    
    var body: some View {
        HStack {
            VStack {
                ReviewHeader(movie: movie,
                             proxy: proxy,
                             style: tmdbViewModel.selectedCandidate!.style)
                    .navigationTitle("Review")
                    .navigationBarTitleDisplayMode(.inline)
                
                ReviewBody(movie: movie)
                
                Spacer()
            }

            ReviewTextEditor()
                .padding(.leading)
        }
    }
}
