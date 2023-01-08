
import Foundation

public enum ServiceExampleError: Error {

    case unexpected
    case builderError
    case noData
    case noConnectivity
}

public protocol ServiceExampleDataAccessProtocol {

    func getServiceExampleData(paramExample: String,
                                completion: @escaping (Result<ServiceExampleModel, ServiceExampleError>) -> Void)
    
    func getServiceExampleWithUrl(from path: String, completion: @escaping (Result<Data, ServiceExampleError>) -> Void)
}

public class ServiceExampleDataAccessFactory {

    public static var shared: ServiceExampleDataAccessProtocol = ServiceExampleDataAccess()
}

public class ServiceExampleDataAccess {

    private let httpClient = HttpClientFactory.shared

    public init() {}

}

extension ServiceExampleDataAccess: ServiceExampleDataAccessProtocol {
    
    public func getServiceExampleData(paramExample: String, completion: @escaping (Result<ServiceExampleModel, ServiceExampleError>) -> Void) {
        let resource = GetServiceExampleResource(paramExample: paramExample)
        
        httpClient.request(with: resource.urlRequest) { result in
            switch result {
            case .success(let data):
                if let model: ServiceExampleModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.builderError))
                }
            case .failure(let error):
                switch error {
                case .noConnectivity:
                    completion(.failure(.noConnectivity))
                default:
                    completion(.failure(.unexpected))
                }
            }
        }
    }
    
    public func getServiceExampleWithUrl(from path: String, completion: @escaping (Result<Data, ServiceExampleError>) -> Void) {
        httpClient.loadData(from: path) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure(let error):
                switch error {
                case .noConnectivity:
                    completion(.failure(.noConnectivity))
                default:
                    completion(.failure(.unexpected))
                }
            }
        }
    }
}


//MARK: - Example of Usage

protocol ServiceExampleDataAccessViewModelProtocol {
    func getServiceExample(paramExample: String)
    var modelDto: ServiceExampleModel? { get }
}

public class ServiceExampleViewModel {
    
    public init() {}
    
    public var modelDto: ServiceExampleModel?
    private let serviceExampleDataAccess = ServiceExampleDataAccessFactory.shared
}

extension ServiceExampleViewModel: ServiceExampleDataAccessViewModelProtocol {
    
    
    
    public func getServiceExample(paramExample: String) {
        serviceExampleDataAccess.getServiceExampleData(paramExample: "example") {[weak self] result in
            switch result {
            case .success(let model):
                print("Model: ", model.response)
                self?.modelDto = model
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
}
 
