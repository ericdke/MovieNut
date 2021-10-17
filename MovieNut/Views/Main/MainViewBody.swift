import SwiftUI

struct MainViewBody: View {
    
    let proxy: GeometryProxy
    @EnvironmentObject var tmdbViewModel: TMDBViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        Group {
            Text("Let's find a movie to review!")
                .font(uiViewModel.mainViewTitleFont)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            if uiViewModel.isPortrait {
                PortraitMainView(proxy: proxy)
            } else {
                LandscapeMainView(proxy: proxy)
            }

            Button("SEARCH") {
                if tmdbViewModel.searchTitle.isBlank {
                    tmdbViewModel.errorMessage = "You must enter (part of) a movie title."
                    tmdbViewModel.showAlert.toggle()
                } else {
                    tmdbViewModel.searchCandidates()
                    uiViewModel.showCandidates.toggle()
                }
            }
            .primaryProminentStyle()
            .padding()
        }
        .onTapGesture {
            withAnimation {
                uiViewModel.searchTextFieldIsFocused = false
            }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
}
