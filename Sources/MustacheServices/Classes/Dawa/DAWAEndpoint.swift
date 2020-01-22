import Foundation

public enum DAWAEndpoint {

    case get(searchText: String, type: AutoCompleteType)
    case getAddress(href: String, type: AutoCompleteType)
    case nearest(latitude: Double, longitude: Double, type: AutoCompleteType)
    case getZip(searchText: String)

}

extension DAWAEndpoint: Endpoint {

    public var baseURL: URL { return URL(string: "https://dawa.aws.dk")! }

    public var method: RequestType { return .get }

    public var path: String {
        switch self {
            case .get: return "/autocomplete"
            case .getAddress(let href, let type): return "/\(type.rawValue)r/\(href)"
            case .nearest(_, _, let type): return "/\(type)r/reverse"
            case .getZip: return "/postnumre/autocomplete"
        }
    }

    public var parameters: [String: String]? {
        switch self {
            case .get(let searchText, let type):
                return ["q": searchText, "type": type.rawValue, "fuzzy": "true", "startfra": "adgangsadresse"]
            case .nearest(let latitude, let longitude, _):
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
    public func getAutoCompleteChoices(searchText: String, type: AutoCompleteType, completionHandler: @escaping (Result<[AutoCompleteModel], Error>) -> ()) -> URLSessionDataTask {
        let endpoint = DAWAEndpoint.get(searchText: searchText, type: type)
        return self.send(endpoint: endpoint, completionHandler: completionHandler)
    }

    @discardableResult
    public func getAddress(href: String, type: AutoCompleteType, completionHandler: @escaping (Result<DAWAAddressProtol, Error>) -> ()) -> URLSessionDataTask {
        let endpoint = DAWAEndpoint.getAddress(href: href, type: type)

        switch type {
            case .adresse:
                return self.send(endpoint: endpoint, completionHandler: { (result: Result<DAWAAdresse, Error>) in
                    switch result {
                        case .success(let address): completionHandler(.success(address))
                        case .failure(let error): completionHandler(.failure(error))
                    }
                })
            case .adgangsadresse:
                return self.send(endpoint: endpoint, completionHandler: { (result: Result<DAWAAdgangsadresse, Error>) in
                    switch result {
                        case .success(let address): completionHandler(.success(address))
                        case .failure(let error): completionHandler(.failure(error))
                    }
                })
            case .vejnavn:
                fatalError()
        }
    }

    @discardableResult
    public func getNearestAddress(latitude: Double, longitude: Double, type: AutoCompleteType, completionHandler: @escaping (Result<DAWAAddressProtol, Error>) -> ()) -> URLSessionDataTask {
        let endpoint = DAWAEndpoint.nearest(latitude: latitude, longitude: longitude, type: type)
        switch type {
            case .adresse:
                return self.send(endpoint: endpoint, completionHandler: { (result: Result<DAWAAdresse, Error>) in
                    switch result {
                        case .success(let address): completionHandler(.success(address))
                        case .failure(let error): completionHandler(.failure(error))
                    }
                })
            case .adgangsadresse:
                return self.send(endpoint: endpoint, completionHandler: { (result: Result<DAWAAdgangsadresse, Error>) in
                    switch result {
                        case .success(let address): completionHandler(.success(address))
                        case .failure(let error): completionHandler(.failure(error))
                    }
                })
            case .vejnavn:
                fatalError()
        }
    }

    @discardableResult
    public func getAutoCompleteZip(searchText: String, completionHandler: @escaping (Result<[ZipAutoCompleteModel], Error>) -> ()) -> URLSessionDataTask {
        let endpoint = DAWAEndpoint.getZip(searchText: searchText)
        return self.send(endpoint: endpoint, completionHandler: completionHandler)
    }
}
