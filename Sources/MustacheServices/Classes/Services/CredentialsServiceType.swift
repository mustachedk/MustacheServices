
import Foundation

public protocol CredentialsServiceType: Service {

    var IsLoggedIn: Bool { get }

    var bearer: String? { get set }

    var accessToken: String? { get set }

    var refreshToken: String? { get set }

    var username: String? { get set }

    var password: String? { get set }

}

public class CredentialsService: NSObject, CredentialsServiceType {

    public var IsLoggedIn: Bool { return self.bearer != nil }

    public var bearer: String? {
        get { return KeychainWrapper.standard.string(forKey: #function) }
        set { if let value = newValue { KeychainWrapper.standard.set(value, forKey: #function) } else { KeychainWrapper.standard.removeObject(forKey: #function) } }
    }

    public var accessToken: String? {
        get { return KeychainWrapper.standard.string(forKey: #function) }
        set { if let value = newValue { KeychainWrapper.standard.set(value, forKey: #function) } else { KeychainWrapper.standard.removeObject(forKey: #function) } }
    }

    public var refreshToken: String? {
        get { return KeychainWrapper.standard.string(forKey: #function) }
        set { if let value = newValue { KeychainWrapper.standard.set(value, forKey: #function) } else { KeychainWrapper.standard.removeObject(forKey: #function) } }
    }

    public var username: String? {
        get { return KeychainWrapper.standard.string(forKey: #function) }
        set { if let value = newValue { KeychainWrapper.standard.set(value, forKey: #function) } else { KeychainWrapper.standard.removeObject(forKey: #function) } }
    }

    public var password: String? {
        get { return KeychainWrapper.standard.string(forKey: #function) }
        set { if let value = newValue { KeychainWrapper.standard.set(value, forKey: #function) } else { KeychainWrapper.standard.removeObject(forKey: #function) } }
    }

    required public init(services: Services) {}

    public func clearState() {
        self.bearer = nil
        self.accessToken = nil
        self.refreshToken = nil
        self.username = nil
        self.password = nil
    }

}
