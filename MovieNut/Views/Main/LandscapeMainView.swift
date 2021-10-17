import SwiftUI

struct LandscapeMainView: View {
    
    let proxy: GeometryProxy
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var scale: CGFloat {
        if uiViewModel.isIphoneLandscape {
            return 1
        } else {
            return uiViewModel.fullWidthFormScale
        }
    }
    
    var body: some View {
        HStack {
            SearchFormGroup()
        }
        .frame(maxWidth: proxy.size.width * scale)
        .centeredInSpacedHStack()
    }
}
