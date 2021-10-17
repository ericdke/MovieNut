import SwiftUI

struct PosterImageReplacement: View {
    var body: some View {
        Image(systemName: "rectangle.portrait.slash")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
    }
}

struct PosterImageReplacement_Previews: PreviewProvider {
    static var previews: some View {
        PosterImageReplacement()
    }
}
