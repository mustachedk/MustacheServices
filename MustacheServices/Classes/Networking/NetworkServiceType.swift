import Foundation

public protocol NetworkServiceType: Service {

    func send<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> ()) -> URLSessionDataTask

    func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder, completionHandler: @escaping (Result<T, Error>) -> ()) -> URLSessionDataTask

}

public class NetworkService: NSObject, NetworkServiceType {

    fileprivate let credentialsService: CredentialsServiceType

    required public init(services: Services) throws {
        self.credentialsService = try services.get()
        super.init()
    }

    public func send<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> ()) -> URLSessionDataTask {
        return self.send(endpoint: endpoint, using: JSONDecoder(), completionHandler: completionHandler)
    }

    public func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder, completionHandler: @escaping (Result<T, Error>) -> ()) -> URLSessionDataTask {

        if let demoData = endpoint.demoData as? T {
            completionHandler(.success(demoData))
            return URLSession.shared.dataTask(with: URL(string: "http://wwww.google.dk")!)
        }

        var request = endpoint.request()

        if endpoint.authentication == .bearer, let token = self.credentialsService.bearer {

            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        } else if endpoint.authentication == .basic, let username = self.credentialsService.username, let password = self.credentialsService.password {

            let raw = String(format: "%@:%@", username, password)
            let data = raw.data(using: .utf8)!
            let encoded = data.base64EncodedString()
            request.addValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(NetworkServiceTypeError.invalidResponseType))
                return
            }

            guard response.statusCode < 400 else {
                completionHandler(.failure(NetworkServiceTypeError.unSuccessful(response.statusCode, error)))
                return
            }

            do {
                let model: T = try decoder.decode(T.self, from: data ?? Data())
                completionHandler(.success(model))
            } catch let error {
                completionHandler(.failure(NetworkServiceTypeError.decodingError(error)))
            }
        }
        task.resume()

        return task
    }

    public func clearState() {}
}

public enum NetworkServiceTypeError: Error {
    case decodingError(Error)
    case invalidResponseType
    case unSuccessful(Int, Error?)
}

