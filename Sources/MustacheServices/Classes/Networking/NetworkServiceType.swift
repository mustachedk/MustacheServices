import Foundation
import Resolver

public protocol NetworkServiceType: AnyObject {

    func send<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> ()) -> Cancellable

    func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder, completionHandler: @escaping (Result<T, Error>) -> ()) -> Cancellable

}

public class NetworkService: NetworkServiceType {

    @Injected
    fileprivate var credentialsService: CredentialsServiceType

    public init() {}

    public func send<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> ()) -> Cancellable {
        return self.send(endpoint: endpoint, using: JSONDecoder(), completionHandler: completionHandler)
    }

    public func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder, completionHandler: @escaping (Result<T, Error>) -> ()) -> Cancellable {

        if let demoData = endpoint.demoData as? T {
            completionHandler(.success(demoData))
            return URLSession.shared.dataTask(with: URL(string: "http://wwww.google.dk")!)
        }

        var request = endpoint.request()

        if endpoint.authentication == .oauth {
            guard let token = self.credentialsService.oauthToken, token.accessTokenExpiration > Date() else {
                completionHandler(.failure(NetworkServiceTypeError.accessTokenExpired))
                if endpoint.useLegacyHTTP {
                    return NSURLConnection(request: request, delegate: nil, startImmediately: true)!
                } else {
                    return URLSession.shared.dataTask(with: URL(string: "http://wwww.google.dk")!)
                }
                
            }
            request.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")

        } else if endpoint.authentication == .oauth2 {
            guard let token = self.credentialsService.oauthToken2, token.accessTokenExpiration > Date() else {
                completionHandler(.failure(NetworkServiceTypeError.accessTokenExpired))
                if endpoint.useLegacyHTTP {
                    return NSURLConnection(request: request, delegate: nil, startImmediately: true)!
                } else {
                    return URLSession.shared.dataTask(with: URL(string: "http://wwww.google.dk")!)
                }
                
            }
            request.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
            
        } else if endpoint.authentication == .bearer, let token = self.credentialsService.bearer {

            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        } else if endpoint.authentication == .basic, let username = self.credentialsService.username, let password = self.credentialsService.password {

            let raw = String(format: "%@:%@", username, password)
            let data = raw.data(using: .utf8)!
            let encoded = data.base64EncodedString()
            request.addValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        }

        if endpoint.useLegacyHTTP {
            let queue = OperationQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: queue) { [weak self] (response, data, error) in
                self?.internalHandler(decoder: decoder, completionHandler: completionHandler, data: data, response: response, error: error)
            }
            return queue
            
        } else {
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                self?.internalHandler(decoder: decoder, completionHandler: completionHandler, data: data, response: response, error: error)
            }
            task.resume()
            return task
        }
    }


    
    private func internalHandler<T: Decodable>(decoder: JSONDecoder, completionHandler: @escaping (Result<T, Error>) -> (), data: Data?, response: URLResponse?, error: Error?) {
        guard let urlResponse = response as? HTTPURLResponse else {
            completionHandler(.failure(NetworkServiceTypeError.invalidResponseType(response, data)))
            return
        }
        
        guard urlResponse.statusCode != 204 else {
            guard let reply = EmptyReply() as? T else {
                completionHandler(.failure(NetworkServiceTypeError.invalidResponseType(response, data)))
                return
            }
            completionHandler(.success(reply))
            return
        }
        
        guard urlResponse.statusCode < 400 else {
            completionHandler(.failure(NetworkServiceTypeError.unSuccessful(urlResponse, data, urlResponse.statusCode, error)))
            return
        }
        
        do {
            let model: T = try decoder.decode(T.self, from: data ?? Data())
            completionHandler(.success(model))
        } catch let error {
            completionHandler(.failure(NetworkServiceTypeError.decodingError(urlResponse, data, error)))
        }
    }
    
}

public enum NetworkServiceTypeError: Error {
    case decodingError(URLResponse?, Data?, Error)
    case invalidResponseType(URLResponse?, Data?)
    case unSuccessful(URLResponse?, Data?, Int, Error?)
    case accessTokenExpired
    case refreshTokenExpired
}
