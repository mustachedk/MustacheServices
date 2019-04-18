import Foundation
#if MustacheRx
import RxSwift
#endif


protocol DAWAServiceType: Service {

    func choices(searchText: String, completionHandler: @escaping (Result<[AutoCompleteModel], Error>) -> ())

    func address(href: String, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ())

    func nearest(latitude: Double, longitude: Double, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ())

    #if MustacheRx

    public func choices(searchText: String) -> Observable<[AutoCompleteModel]>

    public func address(href: String) -> Observable<AutoCompleteAddress>

    public func nearest(latitude: Double, longitude: Double) -> Observable<AutoCompleteAddress>

    #endif

}

public final class DAWAService: NSObject, DAWAServiceType {

    fileprivate let networkService: NetworkServiceType

    required public init(services: Services) throws {
        self.networkService = try services.get()
        super.init()
    }

    public func choices(searchText: String, completionHandler: @escaping (Result<[AutoCompleteModel], Error>) -> ()) {
        self.networkService.getAutoCompleteChoices(searchText: searchText, completionHandler: completionHandler)
    }

    public func address(href: String, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ()) {
        self.networkService.getAddress(href: href, completionHandler: completionHandler)
    }

    public func nearest(latitude: Double, longitude: Double, completionHandler: @escaping (Result<AutoCompleteAddress, Error>) -> ()) {
        self.networkService.getNearestAddress(latitude: latitude, longitude: longitude, completionHandler: completionHandler)
    }

    #if MustacheRx

    public func choices(searchText: String) -> Observable<[AutoCompleteModel]> {
        return self.networkService.getAutoCompleteChoices(searchText: searchText).asObservable()
    }

    public func address(href: String) -> Observable<AutoCompleteAddress> {
        return self.networkService.getAddress(href: href).asObservable()
    }

    public func nearest(latitude: Double, longitude: Double) -> Observable<AutoCompleteAddress> {
        return self.networkService.getNearestAddress(latitude: latitude, longitude: longitude).asObservable()
    }

    #endif

    public func clearState() {}

}
