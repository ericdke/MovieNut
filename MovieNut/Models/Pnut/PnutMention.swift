import Foundation

struct PnutMention: Codable {
    
    let id: String
    let is_copy: Bool?
    let is_leading: Bool?
    let len: Int
    let pos: Int
    let text: String
    
}
