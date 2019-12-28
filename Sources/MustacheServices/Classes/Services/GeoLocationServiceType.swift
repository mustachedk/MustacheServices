
import Foundation
import UIKit
import CoreLocation

public protocol GeoLocationServiceTypeDelegate: NSObjectProtocol {

    func authorized(result: Bool)

    func location(location: CLLocation)
}

public protocol GeoLocationServiceType {

    var delegate: GeoLocationServiceTypeDelegate? { get set }

}

public class GeoLocationService: NSObject, GeoLocationServiceType, CLLocationManagerDelegate {

    public weak var delegate: GeoLocationServiceTypeDelegate? = nil {
        didSet {
            self.delegate != nil ? self.locationManager.startUpdatingLocation() : self.locationManager.stopUpdatingLocation()
        }
    }

    fileprivate let locationManager = CLLocationManager()

    public override init() {
        super.init()
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.delegate = self

        self.locationManager.requestWhenInUseAuthorization()

    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let first = locations.first { self.delegate?.location(location: first) }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.delegate?.authorized(result: status == .authorizedWhenInUse || status == .authorizedAlways)
    }

}
