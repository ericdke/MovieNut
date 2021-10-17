import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var pnutViewModel: PnutViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LoginWebView(origin: .settings), isActive: $pnutViewModel.showLoginFromSettings) {
                    EmptyView()
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                
                if pnutViewModel.isLoggedIn {
                    HStack {
                        Text("Logout from Pnut.io")
                            .font(.title3)
                            .padding()
                        
                        Spacer()
                        
                        Button {
                            pnutViewModel.logout()
                        } label: {
                            Text("LOGOUT")
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        .tint(.red)
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    HStack {
                        Text("Login to Pnut.io")
                            .font(.title3)
                            .padding()
                        
                        Spacer()
                        
                        Button {
                            pnutViewModel.showLoginFromSettings.toggle()
                        } label: {
                            Text("LOGIN")
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        .tint(.green)
                        .buttonStyle(.borderedProminent)
                    }
                }
                
                Toggle(isOn: $uiViewModel.slowNetwork) {
                    VStack(alignment: .leading) {
                        Text("Slow network")
                            .font(.title3)
                        
                        Text("Loads smaller images")
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    .padding()
                }
                
                Spacer()
                
                if pnutViewModel.isLoggedIn == false {
                    Text("You need to login to your Pnut.io account in order to open the Movie Club, post reviews, and reply to messages.")
                        .padding()
                }
            }
            .padding(.horizontal)
        }
    }
}
