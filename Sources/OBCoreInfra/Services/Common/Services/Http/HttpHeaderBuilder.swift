public enum ContentType: String, Codable {

    case json = "application/json"
    case query = "application/x-www-form-urlencoded"
    case pdf = "application/pdf"
    case image = "image/jpeg"
    case imagePng = "image/png"
    case docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case zip = "application/zip"
}

public extension ContentType {

    static func fileContentType(with name: String) -> ContentType? {
        if name.lowercased().hasSuffix(".json") {
            return .json
        }

        if name.lowercased().hasSuffix(".pdf") {
            return .pdf
        }

        if name.lowercased().hasSuffix(".jpeg") || name.lowercased().hasSuffix(".jpg") {
            return .image
        }

        if name.lowercased().hasSuffix(".png") {
            return .imagePng
        }

        if name.lowercased().hasSuffix(".docx") {
            return .docx
        }

        if name.lowercased().hasSuffix(".zip") {
            return .zip
        }

        return nil
    }
}

public class HttpHeadersBuilder {
    private var httpHeaders = [String: String]()

    public func contentType(_ contentType: ContentType = .json) -> HttpHeadersBuilder {
        httpHeaders["Content-Type"] = contentType.rawValue
        return self
    }

    public func acceptType() -> HttpHeadersBuilder {
        httpHeaders["Accept"] = "application/json"
        return self
    }

    public func build() -> [String: String] {
        httpHeaders
    }

    public func setValue(_ value: String, to key: String) -> HttpHeadersBuilder {
        httpHeaders[key] = value
        return self
    }
}
