//
// Created by Tommy Hinrichsen on 2019-01-24.
// Copyright (c) 2019 Adoor ApS. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

#if MustacheRx
import RxSwift
import RxSwiftExt
import RxCocoa
#endif

public protocol GeoLocationServiceTypeDelegate: NSObjectProtocol {

    func authorized(result: Bool)

    func location(location: CLLocation)
}

public protocol GeoLocationServiceType: Service {

    var delegate: GeoLocationServiceTypeDelegate? { get set }

    #if MustacheRx

    var authorized: Observable<Bool> {
        get
    }

    var location: Observable<CLLocation> {
        get
    }

    #endif

}

public class GeoLocationService: NSObject, GeoLocationServiceType, CLLocationManagerDelegate {

    public weak var delegate: GeoLocationServiceTypeDelegate? = nil {
        didSet {
            self.delegate != nil ? self.locationManager.startUpdatingLocation() : self.locationManager.stopUpdatingLocation()
        }
    }

    #if MustacheRx

    public var authorized: Observable<Bool>

    public lazy var location: Observable<CLLocation> = {
        return locationManager.rx.didUpdateLocations
                .filter({ (locations: [CLLocation]) -> Bool in
                    return locations.count > 0
                })
                .map({ (locations: [CLLocation]) -> CLLocation in
                    return locations.first!
                })
                .share(replay: 1)
                .do(onSubscribe: { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.changeObserverCount(1)
                }, onDispose: { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.changeObserverCount(-1)
                })
    }()

    fileprivate let disposeBag = DisposeBag()

    #endif

    fileprivate let locationManager = CLLocationManager()

    required public init(services: Services) throws {
        super.init()
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.delegate = self

        #if MustacheRx

        authorized = locationManager.rx.didChangeAuthorizationStatus.map({ (status: CLAuthorizationStatus) -> Bool in
            switch status {
                case .authorizedWhenInUse, .authorizedAlways:
                    return true
                default:
                    return false
            }
        })

        #endif

        self.locationManager.requestWhenInUseAuthorization()

    }

    #if MustacheRx

    fileprivate var observers: Int = 0

    fileprivate func changeObserverCount(_ value: Int) {
        self.observers += value
        if self.observers < 0 {
            fatalError()
        } else if self.observers == 0 {
            self.locationManager.stopUpdatingLocation()
        } else {
            self.locationManager.startUpdatingLocation()

        }
    }

    #endif

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let first = locations.first { self.delegate?.location(location: first) }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.delegate?.authorized(result: status == .authorizedWhenInUse || status == .authorizedAlways)
    }

    public func clearState() {}
}
