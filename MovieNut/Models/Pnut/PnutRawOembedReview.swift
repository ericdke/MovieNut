import Foundation

struct PnutRawOembedReview: Codable {
    
    let title: String
    let rating: Float
    let release_date: String
    let review: String
    let tmdb_id: Int
    let original_title: String?
    let imdb_url: String?
    let director: [String]?
    let cast: [String]?
    let poster_url: String?
    
    func titleWithYear() -> String {
        if !release_date.isBlank {
            if release_date.count > 3 {
                let sub = release_date.substring(to: 4)
                return "\(title) (\(sub))"
            } else if release_date.count == 2 {
                return "\(title) (\(release_date))"
            }
        }
        return title
    }
    
    var smallPosterURL: String? {
        if let u = poster_url {
            return u.replacingOccurrences(of: "w780", with: "w185")
        }
        return nil
    }
}
