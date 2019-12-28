import Foundation
import Resolver

public protocol DAWAServiceType {

    @discardableResult
    func choices(searchText: String, completionHandler: @escaping (Result<[AutoCompleteModel], Error>) -> ()) -> URLSessionDataTask

    @discardableResult
    func address(href: String, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ()) -> URLSessionDataTask

    @discardableResult
    func nearest(latitude: Double, longitude: Double, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ()) -> URLSessionDataTask
    
    @discardableResult
    func zip(searchText: String, completionHandler: @escaping (Result<[ZipAutoCompleteModel], Error>) -> ()) -> URLSessionDataTask

}

public final class DAWAService: DAWAServiceType {

    @Injected
    fileprivate var networkService: NetworkServiceType

    public init() {}

    @discardableResult
    public func choices(searchText: String, completionHandler: @escaping (Result<[AutoCompleteModel], Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getAutoCompleteChoices(searchText: searchText, completionHandler: completionHandler)
    }

    @discardableResult
    public func address(href: String, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getAddress(href: href, completionHandler: completionHandler)
    }

    @discardableResult
    public func nearest(latitude: Double, longitude: Double, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getNearestAddress(latitude: latitude, longitude: longitude, completionHandler: completionHandler)
    }
    
    @discardableResult
    public func zip(searchText: String, completionHandler: @escaping (Result<[ZipAutoCompleteModel], Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getAutoCompleteZip(searchText: searchText, completionHandler: completionHandler)
    }

}
