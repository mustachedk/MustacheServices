import Foundation
import Resolver

public protocol AddressServiceType {
    
    func choices(searchText: String, completionHandler: @escaping (Result<[AutoCompleteContainer], Error>) -> ()) -> URLSessionDataTask
    
    func find(addresse: String, completionHandler: @escaping (Result<[AutoCompleteAdresseContainer], Error>) -> ()) -> URLSessionDataTask
    
    func zipCodes(searchText: String, completionHandler: @escaping (Result<[AutoCompletePostnummerContainer], Error>) -> ()) -> URLSessionDataTask
    
}

class AddressService: NSObject, AddressServiceType {
    
    @Injected
    fileprivate var networkService: NetworkServiceType
    
    func choices(searchText: String, completionHandler: @escaping (Result<[AutoCompleteContainer], Error>) -> ()) -> URLSessionDataTask {
        let endpoint = AddressEndpoint.get(searchText: searchText)
        return self.networkService.send(endpoint: endpoint, completionHandler: completionHandler)
    }
    
    func find(addresse: String, completionHandler: @escaping (Result<[AutoCompleteAdresseContainer], Error>) -> ()) -> URLSessionDataTask {
        let endpoint = AddressEndpoint.find(searchText: addresse)
        return self.networkService.send(endpoint: endpoint, completionHandler: completionHandler)
    }
    
    func zipCodes(searchText: String, completionHandler: @escaping (Result<[AutoCompletePostnummerContainer], Error>) -> ()) -> URLSessionDataTask {
        let endpoint = AddressEndpoint.zip(searchText: searchText)
        return self.networkService.send(endpoint: endpoint, completionHandler: completionHandler)
    }
    
    func clearState() {}
    
}
