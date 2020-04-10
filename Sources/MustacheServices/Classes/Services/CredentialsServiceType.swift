
import Foundation
import MustacheFoundation

public protocol CredentialsServiceType: class {

    var username: String? { get set }

    var password: String? { get set }
    
    var bearer: String? { get set }

    var accessToken: String? { get set }

    var refreshToken: String? { get set }

}

public class CredentialsService: CredentialsServiceType {

    @KeychainOptional(CredentialsConstants.username.rawValue)
    public var username: String?

    @KeychainOptional(CredentialsConstants.password.rawValue)
    public var password: String?
    
    @KeychainOptional(CredentialsConstants.bearer.rawValue)
    public var bearer: String?

    @KeychainOptional(CredentialsConstants.accessToken.rawValue)
    public var accessToken: String?

    @KeychainOptional(CredentialsConstants.refreshToken.rawValue)
    public var refreshToken: String?

    public init() {}

    public func clearState() {
        self.username = nil
        self.password = nil
        self.bearer = nil
        self.accessToken = nil
        self.refreshToken = nil
    }

    public enum CredentialsConstants: String {
        case username, password, bearer, accessToken, refreshToken
    }

}

