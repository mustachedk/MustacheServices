import Foundation

public enum DAWAEndpoint {
    
    case get(searchText: String, type: AutoCompleteType)
    case getAddress(href: String)
    case nearest(latitude: Double, longitude: Double)
    case getZip(searchText: String)

}

extension DAWAEndpoint: Endpoint {

    public var baseURL: URL { return URL(string: "https://dawa.aws.dk")! }

    public var method: RequestType { return .get }

    public var path: String {
        switch self {
            case .get: return "/autocomplete"
            case .getAddress(let href): return "\(URL(string: href)!.path)"
            case .nearest: return "/adgangsadresser/reverse"
            case .getZip: return "/postnumre/autocomplete"
        }
    }

    public var parameters: [String: String]? {
        switch self {
            case .get(let searchText, let type):
                return ["q": searchText, "type": type, "fuzzy": "true"]
            case .nearest(let latitude, let longitude):
                return ["x": "\(longitude)", "y": "\(latitude)"]
            case .getZip(let searchText):
                return ["q": searchText]
            default:
                return nil
        }
    }

    public var body: Encodable? { return nil }

    public var demoData: Decodable? { return nil }
}

extension NetworkServiceType {

    @discardableResult
    public func getAutoCompleteChoices(searchText: String, completionHandler: @escaping (Result<[AutoCompleteModel], Error>) -> ()) -> URLSessionDataTask {
        let endpoint = DAWAEndpoint.get(searchText: searchText)
        return self.send(endpoint: endpoint, completionHandler: completionHandler)
    }

    @discardableResult
    public func getAddress(href: String, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ()) -> URLSessionDataTask {
        let endpoint = DAWAEndpoint.getAddress(href: href)
        return self.send(endpoint: endpoint, completionHandler: completionHandler)
    }

    @discardableResult
    public func getNearestAddress(latitude: Double, longitude: Double, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ()) -> URLSessionDataTask {
        let endpoint = DAWAEndpoint.nearest(latitude: latitude, longitude: longitude)
        return self.send(endpoint: endpoint, completionHandler: completionHandler)
    }

    @discardableResult
    public func getAutoCompleteZip(searchText: String, completionHandler: @escaping (Result<[ZipAutoCompleteModel], Error>) -> ()) -> URLSessionDataTask {
        let endpoint = DAWAEndpoint.getZip(searchText: searchText)
        return self.send(endpoint: endpoint, completionHandler: completionHandler)
    }
}
