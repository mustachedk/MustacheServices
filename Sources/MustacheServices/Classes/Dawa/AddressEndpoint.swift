import Foundation

public enum AddressEndpoint {
    
    case get(searchText: String)
    case find(searchText: String)
    case zip(searchText: String)
    
}

extension AddressEndpoint: Endpoint {
    
    public var baseURL: URL { URL(string: "https://dawa.aws.dk")! }
    
    public var method: RequestType { .get }
    
    public var path: String {
        switch self {
            case .get: return "/autocomplete"
            case .find: return "/adresser/autocomplete"
            case .zip: return "/postnumre/autocomplete"
        }
    }
    
    public var parameters: [String: String]? {
        switch self {
            case .get(let searchText):
                return ["q": searchText, "fuzzy": "true"]
            case .find(let searchText):
                return ["q": searchText]
            case .zip(let searchText):
                return ["q": searchText]
        }
    }
}
