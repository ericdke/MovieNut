import SwiftUI

struct PortraitMainView: View {
    
    let proxy: GeometryProxy
    @EnvironmentObject var uiViewModel: UIViewModel
    
    var body: some View {
        VStack {
            SearchFormGroup()
        }
        .frame(width: proxy.size.width * uiViewModel.fullWidthFormScale)
        .centeredInSpacedHStack()
    }
}
