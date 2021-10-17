import UIKit

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5              = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_8            = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6_8P           = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X              = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_11_PRO         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_12_13_MINI     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_12             = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 844.0
    static let IS_IPHONE_12_PRO         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 844.0
    static let IS_IPHONE_13             = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 844.0
    static let IS_IPHONE_XR_SMAX        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPHONE_XS_MAX         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPHONE_11             = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPHONE_11_PRO_MAX     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPHONE_12_13_PRO_MAX  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 926.0
    static let IS_IPAD                  = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_MINI_4           = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO9             = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_10               = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.SCREEN_MAX_LENGTH == 1080.0
    static let IS_IPAD_PRO10            = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.SCREEN_MAX_LENGTH == 1112.0
    static let IS_IPAD_PRO11            = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.SCREEN_MAX_LENGTH == 1194.0
    static let IS_IPAD_PRO12            = UIDevice.current.userInterfaceIdiom == .pad   && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_IPAD_ALL              = UIDevice.current.userInterfaceIdiom == .pad
    
    static let IS_IPHONE_NOTCH_DEVICE = (UIDevice.current.userInterfaceIdiom == .phone) && (ScreenSize.SCREEN_MAX_LENGTH == 896.0 || ScreenSize.SCREEN_MAX_LENGTH == 812.0)
}

struct Version {
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS9  = (Version.SYS_VERSION_FLOAT >=  9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
    static let iOS11 = (Version.SYS_VERSION_FLOAT >= 11.0 && Version.SYS_VERSION_FLOAT < 12.0)
    static let iOS12 = (Version.SYS_VERSION_FLOAT >= 12.0 && Version.SYS_VERSION_FLOAT < 13.0)
    static let iOS13 = (Version.SYS_VERSION_FLOAT >= 13.0 && Version.SYS_VERSION_FLOAT < 14.0)
    static let iOS14 = (Version.SYS_VERSION_FLOAT >= 14.0 && Version.SYS_VERSION_FLOAT < 15.0)
    static let iOS15 = (Version.SYS_VERSION_FLOAT >= 15.0)
}

struct VersionAndNewer {
    static let iOS9 =  (Version.SYS_VERSION_FLOAT >=  9.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0)
    static let iOS11 = (Version.SYS_VERSION_FLOAT >= 11.0)
    static let iOS12 = (Version.SYS_VERSION_FLOAT >= 12.0)
    static let iOS13 = (Version.SYS_VERSION_FLOAT >= 13.0)
    static let iOS14 = (Version.SYS_VERSION_FLOAT >= 14.0)
    static let iOS15 = (Version.SYS_VERSION_FLOAT >= 15.0)
}
