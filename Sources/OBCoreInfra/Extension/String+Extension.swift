import Foundation

public extension String {

    static func isNilOrEmpty(_ string: String?) -> Bool {
        (string == nil) || (string == "")
    }

    func rawNumbers() -> String {
        return self.compactMap({ Int(String($0)) }).map({ String($0) }).joined()
    }
    
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }

    // MARK: Base64

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        Data(self.utf8).base64EncodedString()
    }

    func toUTF8() -> String? {
        guard let data = Data(base64Encoded: self) else { return self }
        return String(data: data, encoding: .utf8)
    }

    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
