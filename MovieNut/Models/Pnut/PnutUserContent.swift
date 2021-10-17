import Foundation

struct PnutUserContent: Codable {
    
    let avatar_image: PnutAvatarImage
    let cover_image: PnutCoverImage
    let entities: PnutEntities?
    let markdown_text: String?
    let text: String?
    let html: String?
    
}
