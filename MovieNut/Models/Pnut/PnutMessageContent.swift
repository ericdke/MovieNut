import Foundation

struct PnutMessageContent: Codable {
    
    let text: String
    let entities: PnutEntities
    let html: String?
    
}
