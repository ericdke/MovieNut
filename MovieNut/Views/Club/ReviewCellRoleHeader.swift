import SwiftUI

struct ReviewCellRoleHeader: View {
    
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
            
            Spacer()
        }
    }
}
