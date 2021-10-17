import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var tmdbViewModel: TMDBViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack(alignment: .center, spacing: 0) {
                    NavigationLink(destination: CandidatesView(),
                                   isActive: $uiViewModel.showCandidates) {
                        EmptyView()
                    }
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.inline)

                    ScrollView {
                        MainViewBody(proxy: proxy)
                    }

                    Spacer()
                    
                    // Don't show the decorative icons in crammed view or if the keyboard is up
                    if uiViewModel.isIphoneLandscape || uiViewModel.searchTextFieldIsFocused {
                        EmptyView()
                    } else {
                        RefIconGroup()
                        
                        Spacer()
                    }
                }
                .alert(tmdbViewModel.errorMessage, isPresented: $tmdbViewModel.showAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
        .navigationViewStyle(.stack)
        .onRotate { orientation in
            uiViewModel.orientation = orientation
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
            .environmentObject(TMDBViewModel())
            .environmentObject(UIViewModel())
    }
}
