
import Foundation

public protocol CredentialsServiceType: class {

    var username: String? { get set }

    var password: String? { get set }
    
    var bearer: String? { get set }

    var accessToken: String? { get set }

    var refreshToken: String? { get set }

}

public class CredentialsService: CredentialsServiceType {

    @KeychainOptional
    public var username: String?

    @KeychainOptional
    public var password: String?
    
    @KeychainOptional
    public var bearer: String?

    @KeychainOptional
    public var accessToken: String?

    @KeychainOptional
    public var refreshToken: String?

    public init() {}

    public func clearState() {
        self.username = nil
        self.password = nil
        self.bearer = nil
        self.accessToken = nil
        self.refreshToken = nil
    }

}
