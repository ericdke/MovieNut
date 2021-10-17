import Foundation

struct PnutChannelResult: Codable {
    
    let meta: PnutChannelMeta?
    var data: [PnutMessage]?
    
}
