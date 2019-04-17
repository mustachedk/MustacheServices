
import Foundation
import RxSwift

public enum DAWAEndpoint {

    case get(searchText: String)
    case getAddress(href: String)
    case nearest(latitude: Double, longitude: Double)

}

extension DAWAEndpoint: Endpoint {

    public var baseURL: URL { return URL(string: "https://dawa.aws.dk")! }

    public var method: RequestType { return .get }

    public var path: String {
        switch self {
            case .get: return "/autocomplete"
            case .getAddress(let href): return "\(URL(string: href)!.path)"
            case .nearest: return "/adgangsadresser/reverse"
        }
    }

    public var parameters: [String: String]? {
        switch self {
            case .get(let searchText):
                return ["q": searchText, "type": "adgangsadresse", "fuzzy": "true"]
            case .nearest(let latitude, let longitude):
                return ["x": "\(longitude)", "y": "\(latitude)"]
            default:
                return nil
        }
    }

    public var body: Encodable? { return nil }

    public var demoData: Decodable? { return nil }
}

extension APIClientServiceType {

    public func getAutoCompleteChoices(searchText: String) -> Single<[AutoCompleteModel]> {
        let endpoint = DAWAEndpoint.get(searchText: searchText)
        return self.send(endpoint: endpoint)
    }

    public func getAddress(href: String) -> Single<AutoCompleteAddress> {
        let endpoint = DAWAEndpoint.getAddress(href: href)
        return self.send(endpoint: endpoint)
    }

    public func getNearestAddress(latitude: Double, longitude: Double) -> Single<AutoCompleteAddress> {
        let endpoint = DAWAEndpoint.nearest(latitude: latitude, longitude: longitude)
        return self.send(endpoint: endpoint)
    }

}
