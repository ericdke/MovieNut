import SwiftUI

struct MessageCell: View {

    @EnvironmentObject var uiViewModel: UIViewModel
    let message: PnutMessage
    var isReplying: Bool = false
    let style: ContentStyle
    let proxy: GeometryProxy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PnutCellHeader(message: message)
                .cellHeaderStyled()
            
            VStack {
                if let ents = message.content?.entities {
                    Text(message.text.attributed(for: ents, style: style))
                        .font(uiViewModel.cellBodyFont)
                        .fontWeight(.medium)
                } else {
                    Text(message.text)
                        .font(uiViewModel.cellBodyFont)
                        .fontWeight(.medium)
                }
            }
            .padding(.top)

            if isReplying == false {
                CellButtonsRow(message: message, style: style)
                    .padding(.top)
            }
        }
        .foregroundColor(.white)
    }
}
