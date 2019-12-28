
import Foundation

public protocol CredentialsServiceType {

    var username: String? { get set }

    var password: String? { get set }
    
    var bearer: String? { get set }

    var accessToken: String? { get set }

    var refreshToken: String? { get set }

}

public class CredentialsService: CredentialsServiceType {

    public var username: String? {
        get { return KeychainWrapper.standard.string(forKey: #function) }
        set { if let value = newValue { KeychainWrapper.standard.set(value, forKey: #function) } else { KeychainWrapper.standard.removeObject(forKey: #function) } }
    }

    public var password: String? {
        get { return KeychainWrapper.standard.string(forKey: #function) }
        set { if let value = newValue { KeychainWrapper.standard.set(value, forKey: #function) } else { KeychainWrapper.standard.removeObject(forKey: #function) } }
    }
    
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

    public init() {}

    public func clearState() {
        self.username = nil
        self.password = nil
        self.bearer = nil
        self.accessToken = nil
        self.refreshToken = nil
    }

}
