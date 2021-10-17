import Foundation

struct PnutUser: Codable {
    
    let locale: String
    let content: PnutUserContent
    let id: String
    let created_at: String
    let counts: PnutUserCounts
    let timezone: String
    let username: String
    let type: String
    let name: String?
    
    let follows_you: Bool?
    let you_blocked: Bool?
    let you_can_follow: Bool?
    let you_follow: Bool?
    let you_muted: Bool?
    let verified: PnutVerified?
    
}
