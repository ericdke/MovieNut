import Foundation

struct PnutSimpleMeta: Codable {
    
    let code: Int
    let error_message: String?
    let error_id: String?
    
}

struct PnutPostedMessageResult: Codable {
    
    let meta: PnutSimpleMeta
    let data: PnutMessage
    
}
