import Foundation

public protocol Endpoint {

    var baseURL: URL { get }

    var method: RequestType { get }

    var path: String { get }

    var parameters: [String: String]? { get }

    var headers: [String: String] { get }

    var body: Encodable? { get }

    var demoData: Decodable? { get }

    var authentication: Authentication { get }
}

public extension Endpoint {

    var method: RequestType { return .get }

    var parameters: [String: String]? { return nil }

    var headers: [String: String] { return [:] }

    var body: Encodable? { return nil }

    var demoData: Decodable? { return nil }

    var authentication: Authentication { return .none }

}

public enum Authentication {
    case none
    case basic
    case bearer
}

public extension Endpoint {

    func request() -> URLRequest {

        guard var components = URLComponents(url: self.baseURL.appendingPathComponent(self.path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        if let parameters = self.parameters {
            components.queryItems = parameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        for (key, value) in self.headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        if let body = self.body {
            let wrapper = EncodableWrapper(body)
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(wrapper) else { fatalError("Unable to encode body \(body)") }
            request.httpBody = data
        }
        return request
    }

}
