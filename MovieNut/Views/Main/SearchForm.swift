import SwiftUI

struct SearchForm: View {

    let formTitle: String
    let formPlaceholder: String
    @Binding var formTarget: String
    let style: ContentStyle
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(formTitle)
                    .font(uiViewModel.isVeryCompact ? .subheadline : .headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                
                Spacer()
            }

            TextField(formPlaceholder, text: $formTarget)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 5)
                .onTapGesture {
                    withAnimation {
                        uiViewModel.searchTextFieldIsFocused = true
                    }
                }
        }
        .inColoredCell(cornerRadius: 12, color: style.color)
    }
}
