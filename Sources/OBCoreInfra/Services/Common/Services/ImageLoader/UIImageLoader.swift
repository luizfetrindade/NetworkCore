import Foundation
import UIKit

public protocol UIImageLoaderProtocol {

    func load(_ url: URL, for imageView: UIImageView, completion: ((_ success: Bool) -> Void)?)
    func cancel(for imageView: UIImageView)
}

public class UIImageLoaderFactory {

    public static var shared: UIImageLoaderProtocol = UIImageLoader()
}

public class UIImageLoader: UIImageLoaderProtocol {

    private let imageLoader = ImageLoaderFactory.shared
    private var uuidMap = [UIImageView: UUID]()

    public init() {}

    public func load(_ url: URL, for imageView: UIImageView, completion: ((_ success: Bool) -> Void)?) {
        let token = imageLoader.loadImage(url) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                    completion?(true)
                }
            } catch {
                completion?(false)
            }
        }

        if let token = token {
            uuidMap[imageView] = token
        }
    }

    public func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}
