import Foundation
import Resolver

public protocol DAWAServiceType: class {

    @discardableResult
    func choices(searchText: String, completionHandler: @escaping (Result<[DAWAAddressSuggestion], Error>) -> ()) -> URLSessionDataTask

    @discardableResult
    func address(href: String, completionHandler: @escaping (Result<DAWAAddress, Error>) -> ()) -> URLSessionDataTask

    @discardableResult
    func nearest(latitude: Double, longitude: Double, completionHandler: @escaping (Result<DAWAAddress, Error>) -> ()) -> URLSessionDataTask
    
    @discardableResult
    func zip(searchText: String, completionHandler: @escaping (Result<[DAWAZipSuggestion], Error>) -> ()) -> URLSessionDataTask

}

public final class DAWAService: DAWAServiceType {

    @Injected
    fileprivate var networkService: NetworkServiceType

    public init() {}

    @discardableResult
    public func choices(searchText: String, completionHandler: @escaping (Result<[DAWAAddressSuggestion], Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getAutoCompleteChoices(searchText: searchText, completionHandler: completionHandler)
    }

    @discardableResult
    public func address(href: String, completionHandler: @escaping (Result<DAWAAddress, Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getAddress(href: href, completionHandler: completionHandler)
    }

    @discardableResult
    public func nearest(latitude: Double, longitude: Double, completionHandler: @escaping (Result<DAWAAddress, Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getNearestAddress(latitude: latitude, longitude: longitude, completionHandler: completionHandler)
    }
    
    @discardableResult
    public func zip(searchText: String, completionHandler: @escaping (Result<[DAWAZipSuggestion], Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getAutoCompleteZip(searchText: searchText, completionHandler: completionHandler)
    }

}
