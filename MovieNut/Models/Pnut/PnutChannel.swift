import Foundation

struct PnutChannel: Codable {
    
    let id: String
    let is_active: Bool?
    let type: String
    let recent_message_id: String?
    let recent_message: PnutMessage?
    let you_subscribed: Bool
    let you_muted: Bool
    let has_unread: Bool
    let counts: PnutChannelCounts
    
}
