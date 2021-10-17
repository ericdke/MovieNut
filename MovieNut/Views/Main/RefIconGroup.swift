import SwiftUI

struct RefIconGroup: View {
    var body: some View {
        HStack(spacing: 20) {
            Image("poweredbytmdb")
                .resizable()
                .frame(width: 84, height: 84)
            
            Image("pnuticon")
                .resizable()
                .frame(width: 84, height: 84)
        }
    }
}

struct RefIconGroup_Previews: PreviewProvider {
    static var previews: some View {
        RefIconGroup()
    }
}
