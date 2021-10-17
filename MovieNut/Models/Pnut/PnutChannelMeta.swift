import Foundation

struct PnutChannelMeta: Codable {
    
    let marker: PnutMarker?
    let more: Bool
    let max_id: String?
    let min_id: String?
    let code: Int
    let error_message: String?
    let error_id: String?
    let deleted_ids: [String]?
    
}
