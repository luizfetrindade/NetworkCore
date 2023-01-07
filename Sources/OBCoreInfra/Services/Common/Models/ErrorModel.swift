import Foundation

public struct ErrorModel: Model {

    public let code: Int
    public let name, errorModelDescription, friendlyMessage: String
    public var extra: [String: String?]?

    public init(code: Int, name: String, errorModelDescription: String, friendlyMessage: String, extra: [String: String?]?) {
        self.code = code
        self.name = name
        self.errorModelDescription = errorModelDescription
        self.friendlyMessage = friendlyMessage
        self.extra = extra
    }

    private enum CodingKeys: String, CodingKey {

        case code, name, extra
        case errorModelDescription = "description"
        case friendlyMessage = "friendly_message"
    }
}
