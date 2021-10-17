import SwiftUI

extension Button {
    
    func primaryProminentStyle(_ color: Color = .customPrimary) -> some View {
        self
            .tint(color)
            .buttonStyle(.borderedProminent)
    }
    
}

