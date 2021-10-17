import Foundation

struct PnutToken: Codable {
    
    let user: PnutUser
    let app: PnutApp
    let scopes: [String]
    let storage: PnutStorage
    
}
