import Foundation

public class APIURL {

    public static var base: String {
#if DEV
        localizedString(forKey: "http://localhost:3002")
#else
        localizedString(forKey: "http://localhost:3002")
#endif
    }

    // MARK: Private Methods

    private static func localizedString(forKey key: String) -> String {
        Bundle(for: Self.self).localizedString(forKey: key, value: nil, table: "SafeConstants")
    }
}
