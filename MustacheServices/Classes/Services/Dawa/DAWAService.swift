
import Foundation
import RxSwift

protocol DAWAServiceType: Service {

    func choices(searchText: String) -> Observable<[AutoCompleteModel]>

    func address(href: String) -> Observable<AutoCompleteAddress>

    func nearest(latitude: Double, longitude: Double) -> Observable<AutoCompleteAddress>

}

public final class DAWAService: NSObject, DAWAServiceType {

    fileprivate let apiClient: APIClientServiceType

    required public init(services: Services) throws {
        self.apiClient = try services.get()
        super.init()
    }

    public func choices(searchText: String) -> Observable<[AutoCompleteModel]> {
        return self.apiClient.getAutoCompleteChoices(searchText: searchText).asObservable()
    }

    public func address(href: String) -> Observable<AutoCompleteAddress> {
        return self.apiClient.getAddress(href: href).asObservable()
    }

    public func nearest(latitude: Double, longitude: Double) -> Observable<AutoCompleteAddress> {
        return self.apiClient.getNearestAddress(latitude: latitude, longitude: longitude).asObservable()
    }

    public func clearState() {}

}
