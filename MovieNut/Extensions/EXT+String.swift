import SwiftUI

extension String {
    
    var prettyReleaseDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime]
        if let date = formatter.date(from: self) {
            let df = DateFormatter()
            df.locale = Locale.current
            df.timeZone = TimeZone.current
            df.dateFormat = "yyyy/MM/dd"
            return df.string(from: date)
        }
        return self
    }
    
    var prettyDetailedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime]
        if let date = formatter.date(from: self) {
            let df = DateFormatter()
            df.locale = Locale.current
            df.timeZone = TimeZone.current
            df.dateFormat = "yyyy/MM/dd HH:mm"
            return df.string(from: date)
        }
        return self
    }
    
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func addingURLComponent(component: String, first: Bool = false) -> String {
        if first {
            return "\(self)?\(component)"
        } else {
            return "\(self)&\(component)"
        }
    }
    
    func jsonDataForMessage() -> Data {
        let obj: [String: Any] = ["text": self]
        return try! JSONSerialization.data(withJSONObject: obj, options: [])
    }
    
    func jsonDataForReply(replyToId: String) -> Data {
        let obj: [String: Any] = ["text": self, "reply_to": replyToId]
        return try! JSONSerialization.data(withJSONObject: obj, options: [])
    }
    
    func attributed(for entities: PnutEntities, style: ContentStyle) -> AttributedString {
        var string = AttributedString(self)
        if let mentions = entities.mentions {
            for mention in mentions {
                let u = "@\(mention.text)"
                if let range = string.range(of: u) {
                    switch style {
                    case .primary:
                        string[range].foregroundColor = .indigo
                    case .secondary:
                        string[range].foregroundColor = .pink
                    default:
                        string[range].foregroundColor = .black
                    }
                }
            }
        }
        if let tags = entities.tags {
            for tag in tags {
                let t = "#\(tag.text)"
                if let range = string.range(of: t) {
                    string[range].foregroundColor = .green
                }
            }
        }
        if let links = entities.links {
            for link in links {
                if let range = string.range(of: link.text) {
                    string[range].link = URL(string: link.link)!
                    switch style {
                    case .primary:
                        string[range].foregroundColor = .indigo
                    case .secondary:
                        string[range].foregroundColor = .pink
                    default:
                        string[range].foregroundColor = .blue
                    }
                }
            }
        }
        return string
    }
    
}
