import SwiftUI

struct CandidatesView: View {
    
    @EnvironmentObject var tmdbViewModel: TMDBViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                NavigationLink(destination: ReviewView(proxy: proxy),
                               isActive: $tmdbViewModel.showReviewView) {
                    EmptyView()
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach(tmdbViewModel.candidates.indices, id: \.self) { index in
                            MovieCell(movie: tmdbViewModel.candidates[index],
                                      proxy: proxy,
                                      style: ContentStyle(index))
                                .padding(.bottom)
                                .onAppear {
                                    tmdbViewModel.getNextCandidatesPageIfNeeded(index: index)
                                }.onTapGesture {
                                    tmdbViewModel.selectedCandidate = SelectedCandidate(candidate: tmdbViewModel.candidates[index], style: ContentStyle(index))
                                    tmdbViewModel.showReviewView.toggle()
                                }
                        }
                    }
                }
                .navigationTitle(tmdbViewModel.searchNavigationTitle)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
