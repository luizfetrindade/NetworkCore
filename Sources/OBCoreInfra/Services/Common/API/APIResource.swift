import Foundation

public protocol APIResource {

    var url: URL { get }
    var httpMethod: HttpMethod { get }
    var httpHeaders: [String: String]? { get }
    var httpBody: Data? { get }
}

public extension APIResource {

    var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = httpHeaders
        urlRequest.httpBody = httpBody
        return urlRequest
    }
}
