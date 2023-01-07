import Foundation

public extension Dictionary {

    func toString() -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }

    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

public extension Dictionary {

    var allKeys: [Dictionary.Key] {
        return self.keys.map { $0 }
    }

    var allValues: [Dictionary.Value] {
        return self.values.map { $0 }
    }
}
