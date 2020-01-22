import Foundation

public protocol DAWAServiceType: Service {

    @discardableResult
    func choices(searchText: String, type: AutoCompleteType, completionHandler: @escaping (Result<[AutoCompleteModel], Error>) -> ()) -> URLSessionDataTask

    @discardableResult
    func address(href: String, type: AutoCompleteType, completionHandler: @escaping (Result<DAWAAddressProtol, Error>) -> ()) -> URLSessionDataTask

    @discardableResult
    func nearest(latitude: Double, longitude: Double, type: AutoCompleteType, completionHandler: @escaping (Result<DAWAAddressProtol, Error>) -> ()) -> URLSessionDataTask

    @discardableResult
    func zip(searchText: String, completionHandler: @escaping (Result<[ZipAutoCompleteModel], Error>) -> ()) -> URLSessionDataTask

}

public final class DAWAService: NSObject, DAWAServiceType {

    fileprivate let networkService: NetworkServiceType

    required public init(services: Services) throws {
        self.networkService = try services.get()
        super.init()
    }

    @discardableResult
    public func choices(searchText: String, type: AutoCompleteType, completionHandler: @escaping (Result<[AutoCompleteModel], Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getAutoCompleteChoices(searchText: searchText, type: type, completionHandler: completionHandler)
    }

    @discardableResult
    public func address(href: String, type: AutoCompleteType, completionHandler: @escaping (Result<DAWAAddressProtol, Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getAddress(href: href, type: type, completionHandler: completionHandler)
    }

    @discardableResult
    public func nearest(latitude: Double, longitude: Double, type: AutoCompleteType, completionHandler: @escaping (Result<DAWAAddressProtol, Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getNearestAddress(latitude: latitude, longitude: longitude, type: type, completionHandler: completionHandler)
    }

    @discardableResult
    public func zip(searchText: String, completionHandler: @escaping (Result<[ZipAutoCompleteModel], Error>) -> ()) -> URLSessionDataTask {
        return self.networkService.getAutoCompleteZip(searchText: searchText, completionHandler: completionHandler)
    }

    public func clearState() {}

}
