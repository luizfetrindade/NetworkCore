import Foundation

struct GetServiceExampleResource: APIResource {

    var paramExample: String
    
    var url: URL { URL(string: APIURL.base
                       + APIEndpoints.mock +
                       "/\(paramExample)")! }

    var httpMethod: HttpMethod { .get }

    var httpHeaders: [String: String]? {
        HttpHeadersBuilder()
            .contentType()
            .acceptType()
            .build()
    }

    var httpBody: Data?
}
