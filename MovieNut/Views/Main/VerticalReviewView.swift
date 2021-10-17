import SwiftUI

struct VerticalReviewView: View {

    let proxy: GeometryProxy
    @EnvironmentObject var tmdbViewModel: TMDBViewModel
    
    var movie: Movie {
        tmdbViewModel.selectedCandidate!.candidate
    }
    
    var body: some View {
        Group {
            ReviewHeader(movie: movie,
                         proxy: proxy,
                         style: tmdbViewModel.selectedCandidate!.style)
                .navigationTitle("Review")
                .navigationBarTitleDisplayMode(.inline)

            ReviewBody(movie: movie)
                .padding(.vertical)
            
            ReviewTextEditor()
        }
    }
}
