import Foundation

struct PnutMessage: Codable {
    
    let created_at: String
    let id: String
    let is_deleted: Bool?
    let is_sticky: Bool?
    let source: PnutSource
    let reply_to: String?
    let thread_id: String
    let user: PnutUser?
    let content: PnutMessageContent?
    let channel_id: String
    let pagination_id: String?
    
    private enum CodingKeys: String, CodingKey {
        case created_at, id, is_deleted, is_sticky, source, reply_to, thread_id, user, content, channel_id, pagination_id
    }
    
    var photos: [PnutRawOembedPhoto]?
    var reviews: [PnutRawOembedReview]?
    
    var handle: String {
        if let u = user?.username {
            return "@\(u)"
        }
        return "[No username]"
    }
    
    var name: String {
        if let n = user?.name {
            return n
        }
        return "[No name]"
    }
    
    var text: String {
        content?.text ?? "[No text]"
    }
    
    var avatar: String? {
        user?.content.avatar_image.link
    }
    
    var avatarSmall: String? {
        if let link = user?.content.avatar_image.link {
            return "\(link)?h=128"
        }
        return nil
    }
}
