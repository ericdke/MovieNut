import SwiftUI

class Keys {
    static let savedToken = "SavedToken"
    static let savedUserToken = "SavedUserToken"
    static let slowNetwork = "SlowNetwork"
}

enum MessagesOrder {
    case since, before, replace
}

struct SelectedCandidate {
    var candidate: Movie
    let style: ContentStyle
}

struct SelectedReplyTarget {
    let target: PnutMessage
    let style: ContentStyle
}

enum LoginOrigin {
    case main, club, settings
}

struct TokenResponse {
    let token: String
    let origin: LoginOrigin
}

enum ContentStyle {
    case primary, secondary, white, black
    
    init(_ index: Int) {
        self = index.isMultiple(of: 2) ? .primary : .secondary
    }
    
    var color: Color {
        switch self {
        case .primary:
            return Color.customPrimary
        case .secondary:
            return Color.customSecondary
        case .white:
            return .white
        case .black:
            return .black
        }
    }
}
