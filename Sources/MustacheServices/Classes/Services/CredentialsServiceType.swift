import Foundation
import MustacheFoundation

public protocol CredentialsServiceType: class {

    var username: String? { get set }

    var password: String? { get set }

    var bearer: String? { get set }

    var oauthToken: OAuthTokenType? { get set }

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

public struct OAuthTokenType: Codable {

    public var accessToken: String
    public var accessTokenExpiration: Date
    public var refreshToken: String?
    public var refreshTokenExpiration: Date?

    public init(accessToken: String, accessTokenExpiration: Date, refreshToken: String? = nil, refreshTokenExpiration: Date? = nil) {
        self.accessToken = accessToken
        self.accessTokenExpiration = accessTokenExpiration
        self.refreshToken = refreshToken
        self.refreshTokenExpiration = refreshTokenExpiration
    }

}
