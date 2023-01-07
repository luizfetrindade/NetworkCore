import Foundation

public enum HttpError: Error {

    case noConnectivity
    case badRequest(Data?)
    case serverError(Data?)
    case unauthorized
    case forbidden
}
