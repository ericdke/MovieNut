import Foundation

struct PnutRawOembedPhoto: Codable {
    
    let version: String
    let width: Int
    let height: Int
    let url: String
    let embeddable_url: String?
    let title: String?
    let author_name: String?
    let author_url: String?
    let provider_name: String?
    let provider_url: String?
    let cache_age: Int?
    let thumbnail_url: String?
    let thumbnail_width: Int?
    let thumbnail_height: Int?
    
}
