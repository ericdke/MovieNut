import Foundation

struct MovieCreditsResult: Codable {
    
    let cast: [CastMember]?
    let crew: [CrewMember]?
    
}
