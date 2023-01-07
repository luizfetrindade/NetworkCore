import Foundation
import UIKit

public protocol ImageLoaderProtocol {

    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID?
    func cancelLoad(_ uuid: UUID)
}

public class ImageLoaderFactory {

    public static var shared: ImageLoaderProtocol  = ImageLoader()
}

public class ImageLoader: ImageLoaderProtocol {

    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()

    public init() {}

    public func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }

        let uuid = UUID()

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            defer {self.runningRequests.removeValue(forKey: uuid) }

            let fileExtension = NSURL(fileURLWithPath: url.absoluteString).pathExtension

            if let data = data,
               let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }

            guard let error = error else {
                return
            }

            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        task.resume()

        runningRequests[uuid] = task
        return uuid
    }

    public func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
