import Foundation

public protocol HttpClientProtocol {
    
    @discardableResult
    func request(with urlRequest: URLRequest, completion: @escaping (Result<Data?, HttpError>) -> Void) -> URLSessionTask?
    func loadData(from urlString: String, completion: @escaping (Result<Data?, HttpError>) -> Void)
}

public class HttpClientFactory {
    
    public static var shared: HttpClientProtocol = HttpClient()
}

public final class HttpClient {}

extension HttpClient: HttpClientProtocol {
    
    public func request(with urlRequest: URLRequest, completion: @escaping (Result<Data?, HttpError>) -> Void) -> URLSessionTask? {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse, error == nil else {
                completion(.failure(.noConnectivity))
                return
            }
            
            switch response.statusCode {
            case 202, 204:
                completion(.success(nil))
            case 200...299, 302:
                completion(.success(data))
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            case 400...499:
                completion(.failure(.badRequest(data)))
            case 500...599:
                completion(.failure(.serverError(data)))
            default:
                completion(.failure(.noConnectivity))
            }
        }
        
        task.resume()

        return task
    }
    
    public func loadData(from urlString: String, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badRequest(nil)))
            return
        }

        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url) else {
                completion(.failure(.noConnectivity))
                return
            }
            completion(.success(data))
        }
    }
}
