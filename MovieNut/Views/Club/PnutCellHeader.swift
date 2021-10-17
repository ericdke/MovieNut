import SwiftUI
import Kingfisher

struct PnutCellHeader: View {
    
    @EnvironmentObject var uiViewModel: UIViewModel
    let message: PnutMessage
    @State private var alreadyDownloadedBigImage = false
    
    var body: some View {
        HStack(alignment: .top) {
            Group {
                if uiViewModel.slowNetwork {
                    if alreadyDownloadedBigImage {
                        KFImage.url(URL(string: message.avatar!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(uiViewModel.posterCornerRadius)
                    } else {
                        if let url = message.avatarSmall {
                            KFImage.url(URL(string: url)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(uiViewModel.posterCornerRadius)
                        } else {
                            PosterImageReplacement()
                        }
                    }
                } else {
                    if let url = message.avatar {
                        KFImage.url(URL(string: url)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(uiViewModel.posterCornerRadius)
                            .onAppear {
                                alreadyDownloadedBigImage = true
                            }
                    } else {
                        PosterImageReplacement()
                    }
                }
            }
            .frame(width: uiViewModel.avatarSize,
                   height: uiViewModel.avatarSize)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(message.handle)
                    .fontWeight(.heavy)
                
                Text(message.name)
                    .fontWeight(.medium)
                
                Text(message.created_at.prettyDetailedDate)
                    .fontWeight(.light)
            }
            .font(uiViewModel.cellBodyFont)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
