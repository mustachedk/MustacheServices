import Foundation

public protocol NetworkServiceType: Service {

    func send<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask

    func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder, completionHandler: @escaping (T?, Error?) -> Void) -> URLSessionDataTask

}

public class NetworkService: NSObject, NetworkServiceType {

    fileprivate let credentialsService: CredentialsServiceType

    required public init(services: Services) throws {
        self.credentialsService = try services.get()
        super.init()
    }

    public func send<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        return self.send(endpoint: endpoint, using: JSONDecoder())
    }

    public func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {

        if let demoData = endpoint.demoData as? T { return Single<T>.just(demoData) }

        var request = endpoint.request()

        if let token = self.credentialsService.bearer {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if let username = self.credentialsService.username, let password = self.credentialsService.password {
            let raw = String(format: "%@:%@", username, password)
            let data = raw.data(using: .utf8)!
            let encoded = data.base64EncodedString()
            request.addValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let response = response as? HTTPURLResponse else { completionHandler(.failure(APIClientError.invalidResponseType)) }

            guard response.statusCode < 400 else { completionHandler(.failure(APIClientError.unSuccessful(response.statusCode, error))) }

            do {
                let model: T = try decoder.decode(T.self, from: data ?? Data())
                completionHandler(.success(model))
            } catch let error {
                completionHandler(.failure(APIClientError.decodingError(error)))
            }
        }
        task.resume()

        return task
    }

    public func clearState() {}
}

public enum APIClientError: Error {
    case decodingError(error)
    case invalidResponseType
    case unSuccessful(Int, Error?)
}
