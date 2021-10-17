import Foundation

extension Float {
    
    func toPrettyString() -> String {
        if self.truncatingRemainder(dividingBy: 1) == 0.0 {
            return String(Int(self))
        } else {
            return String(self)
        }
    }
    
}
