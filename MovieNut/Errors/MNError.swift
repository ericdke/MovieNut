import Foundation

enum MNError: Error {
    case network(message: String)
    case data(message: String)
    case json(message: String)
    
    var description: String {
        switch self {
        case .network(let msg):
            return "Network error: \(msg)"
        case .data(let msg):
            return "Data error: \(msg)"
        case .json(let msg):
            return "JSON error: \(msg)"
        }
    }
}
