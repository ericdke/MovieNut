import SwiftUI

// A SwiftUI wrapper for Cosmos view
struct MNCosmosView: UIViewRepresentable {
    
    let style: ContentStyle
    let size: CGFloat
    var enabled = true
    @Binding var rating: Double

    func makeUIView(context: Context) -> CosmosView {
        CosmosView()
    }

    func updateUIView(_ uiView: CosmosView, context: Context) {
        uiView.rating = rating
        uiView.settings.fillMode = .half
        uiView.settings.filledColor = UIColor(style.color)
        uiView.settings.filledBorderColor = UIColor(style.color)
        uiView.settings.emptyBorderColor = UIColor(style.color)
        uiView.settings.minTouchRating = 0
        uiView.settings.emptyBorderWidth = 2
        uiView.settings.starSize = size
        uiView.settings.updateOnTouch = enabled

        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
