import Foundation

public protocol NetworkServiceType: Service {

    func send<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> ()) -> URLSessionDataTask

    func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder, completionHandler: @escaping (Result<T, Error>) -> ()) -> URLSessionDataTask

    #if MustacheRx

    func send<T: Decodable>(endpoint: APIEndpoint) -> Single<T>

    func send<T: Decodable>(endpoint: APIEndpoint, using decoder: JSONDecoder) -> Single<T>

    #endif
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

        if let token = self.credentialsService.bearer {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if let username = self.credentialsService.username, let password = self.credentialsService.password {
            let raw = String(format: "%@:%@", username, password)
            let data = raw.data(using: .utf8)!
            let encoded = data.base64EncodedString()
            request.addValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(APIClientError.invalidResponseType))
                return
            }

            guard response.statusCode < 400 else {
                completionHandler(.failure(APIClientError.unSuccessful(response.statusCode, error)))
                return
            }

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

    #if MustacheRx

    public func send<T: Decodable>(endpoint: APIEndpoint) -> Single<T> {
        return self.send(endpoint: endpoint, using: JSONDecoder())
    }

    public func send<T: Decodable>(endpoint: APIEndpoint, using decoder: JSONDecoder) -> Single<T> {

        if let demoData = endpoint.demoData as? T { return Single<T>.just(demoData) }

        return Single<T>.create { [weak self] observer in
                    var request = endpoint.request()
                    if let self = self, let token = self.credentialsService.token { request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }
                    let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

                        guard let response = response as? HTTPURLResponse else {
                            observer(.error(APIClientError.invalidResponseType))
                            return
                        }

                        if response.statusCode >= 400 {
                            observer(.error(APIClientError.unSuccessful(response.statusCode, error)))
                            return
                        }

                        do {
                            let model: T = try decoder.decode(T.self, from: data ?? Data())
                            observer(.success(model))
                        } catch let error {
                            observer(.error(APIClientError.decodingError(error)))
                        }

                    }
                    task.resume()

                    return Disposables.create {
                        task.cancel()
                    }
                }
                .observeOn(MainScheduler.instance)

    }

    #endif

    public func clearState() {}
}

public enum APIClientError: Error {
    case decodingError(Error)
    case invalidResponseType
    case unSuccessful(Int, Error?)
}
