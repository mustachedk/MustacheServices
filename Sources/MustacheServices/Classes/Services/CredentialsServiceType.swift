import Foundation
import MustacheFoundation

public protocol CredentialsServiceType: class {

    var username: String? { get set }

    var password: String? { get set }

    var bearer: String? { get set }

    var accessToken: String? { get set }

    var refreshToken: String? { get set }

    func clearState()

}

public class CredentialsService: CredentialsServiceType {

    @KeychainOptional(CredentialsConstants.username.rawValue)
    public var username: String?

    @KeychainOptional(CredentialsConstants.password.rawValue)
    public var password: String?

    @KeychainOptional(CredentialsConstants.bearer.rawValue)
    public var bearer: String?

    @KeychainOptional(CredentialsConstants.oauth.rawValue)
    public var oauthToken: OAuthTokenType?

    public init() {}

    public func clearState() {
        self.username = nil
        self.password = nil
        self.bearer = nil
        self.oauthToken = nil
    }

    public enum CredentialsConstants: String {
        case username, password, bearer, oauth
    }

}

protocol OAuthTokenType: Codable {
    var accessToken: String
    var accessTokenExpiration: Date
    var refreshToken: String?
    var refreshTokenExpiration: Date?
}
