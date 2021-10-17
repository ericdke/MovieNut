import SwiftUI

final class UIViewModel: ObservableObject {

    let posterWidthScale: CGFloat = 0.25
    let posterCornerRadius: CGFloat = 8
    @Published var orientation = UIDeviceOrientation.unknown
    @Published var showCandidates = false
    @Published var showWritePost = false
    @Published var showWriteReply = false
    @Published var showWriteReplyFromThread = false
    @Published var searchTextFieldIsFocused = false
    
    @Published var slowNetwork: Bool = UserDefaults.standard.bool(forKey: Keys.slowNetwork) {
        didSet {
            UserDefaults.standard.set(slowNetwork, forKey: Keys.slowNetwork)
        }
    }
    
    var isIphoneLandscape: Bool {
        isPortrait == false && isIpad == false
    }
    
    var isPortrait: Bool {
        switch orientation {
        case .faceDown, .faceUp, .unknown:
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                return true
            }
            return false
        case .portrait, .portraitUpsideDown:
            return true
        default:
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                return true
            }
            return false
        }
    }

    var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isBigScreen: Bool {
        UIScreen.main.bounds.size.width > 1024 || UIScreen.main.bounds.size.height > 1024
    }
    
    var isVeryCompact: Bool {
        DeviceType.IS_IPHONE_6_8 || DeviceType.IS_IPHONE_6_8P
    }
    
    func reviewHeadersWidth(with proxy: GeometryProxy) -> CGFloat {
        if isIpad {
            return (proxy.size.width * posterWidthScale) / 1.5
        }
        if isPortrait {
            return (proxy.size.width * posterWidthScale) / 1.3
        }
        return (proxy.size.width * posterWidthScale) / 2
    }
    
    func posterWidth(with proxy: GeometryProxy) -> CGFloat {
        if isIpad && !isPortrait {
            return (proxy.size.width * posterWidthScale) / 1.33
        } else {
            if isIphoneLandscape {
                return (proxy.size.width * posterWidthScale) / 2
            }
            return proxy.size.width * posterWidthScale
        }
    }
    
    func posterHeight(with proxy: GeometryProxy) -> CGFloat {
        if isIpad && !isPortrait {
            return ((proxy.size.width * posterWidthScale) * 1.5) / 1.33
        } else {
            if isIphoneLandscape {
                return ((proxy.size.width * posterWidthScale) * 1.5) / 2
            }
            return (proxy.size.width * posterWidthScale) * 1.5
        }
    }
    
    func reviewPosterWidth(with proxy: GeometryProxy) -> CGFloat {
        if !isPortrait {
            return (proxy.size.width * posterWidthScale) / 2.5
        }
        return proxy.size.width * posterWidthScale
    }
    
    func reviewPosterHeight(with proxy: GeometryProxy) -> CGFloat {
        if !isPortrait {
            return ((proxy.size.width * posterWidthScale) * 1.5) / 2.5
        }
        return (proxy.size.width * posterWidthScale) * 1.5
    }
    
    var mainViewTitleFont: Font {
        if isIpad {
            if isPortrait {
                return .largeTitle
            }
            return .title2
        }
        if isVeryCompact {
            return .title3
        }
        return .largeTitle
    }
    
    var reviewHeaderCallToActionFont: Font {
        if isIpad {
            if isBigScreen {
                return .body
            }
            return .subheadline
        }
        return .footnote
    }
    
    var reviewHeaderBodyFont: Font {
        if isIpad && !isPortrait {
            return .body
        }
        if isIpad {
            if isBigScreen {
                return .title
            }
            return .title3
        }
        return .subheadline
    }
    
    var reviewHeadersBottomPadding: CGFloat {
        if isIpad {
            if isBigScreen {
                return 10
            }
            return 8
        }
        return 5
    }
    
    var cellRatingFont: Font {
        if isIpad {
            if isBigScreen {
                return .title
            }
            return .title2
        }
        return .title3
    }
    
    var cellMovieTitleFont: Font {
        if isIpad {
            if isBigScreen {
                return .largeTitle
            }
            return .title2
        }
        return .title3
    }
    
    var cellBodyFont: Font {
        if isIpad {
            if isBigScreen {
                return .title
            }
            return .title3
        }
        return .body
    }
    
    var textBottomPadding: CGFloat {
        if isIpad {
            if isBigScreen {
                return 12
            }
            return 10
        }
        return 7
    }
    
    var cellMaxLines: Int {
        if isIpad {
            if isBigScreen {
                return 32
            }
            return 24
        }
        return 16
    }
    
    var fullWidthFormScale: CGFloat {
        if isIpad {
            if isBigScreen {
                return 0.6
            }
            return 0.7
        }
        return 0.8
    }
    
    var bigStarSize: CGFloat {
        if isIpad && !isPortrait {
            return 36
        }
        if isIpad {
            if isBigScreen {
                return 48
            }
            return 44
        }
        return 36
    }
    
    var smallStarSize: CGFloat {
        if isIpad && !isPortrait {
            return 36
        }
        if isIpad {
            if isBigScreen {
                return 42
            }
            return 38
        }
        return 30
    }
    
    var avatarSize: CGFloat {
        if isIpad {
            if isBigScreen {
                return 84
            }
            return 76
        }
        return 64
    }
    
    var cellIconSize: CGFloat {
        if isIpad {
            if isBigScreen {
                return 28
            }
            return 26
        }
        return 24
    }
}
