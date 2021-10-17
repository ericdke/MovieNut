import SwiftUI

extension View {
    
    func centeredInSpacedHStack() -> some View {
        HStack(alignment: .center) {
            Spacer()
            
            self
            
            Spacer()
        }
    }
    
    func inColoredCell(cornerRadius: CGFloat = 8, color: Color) -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(color)
            )
    }
    
    func cellHeaderStyled() -> some View {
        self
            .cornerRadius(8)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.black)
                    .opacity(0.1)
            )
    }
}
