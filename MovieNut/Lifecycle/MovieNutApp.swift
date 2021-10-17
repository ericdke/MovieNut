import SwiftUI

@main
struct MovieNutApp: App {
    
    // Handles the TMDb API and objects
    @StateObject var tmdbViewModel = TMDBViewModel()
    
    // Handles the UI properties
    @StateObject var uiViewModel = UIViewModel()
    
    // Handles the Pnut.io API and objects
    @StateObject var pnutViewModel = PnutViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MainView()
                    .tabItem {
                        Label("Review", systemImage: "magnifyingglass.circle.fill")
                    }
                
                MovieClubView()
                    .tabItem {
                        Label("Movie Club", systemImage: "message.circle.fill")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.circle.fill")
                    }
            }
            .environmentObject(tmdbViewModel)
            .environmentObject(uiViewModel)
            .environmentObject(pnutViewModel)
            .preferredColorScheme(.dark)
        }
    }
}
