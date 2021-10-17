import Foundation

struct MovieSearchResult: Codable {
    
    let results: [Movie]?
    let total_pages: Int
    let page: Int
    let total_results: Int
    
}
