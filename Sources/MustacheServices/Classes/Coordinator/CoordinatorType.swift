import UIKit

// https://medium.com/concretelatinoamérica/inverse-reference-coordinator-pattern-d5a5948c0d90
public protocol CoordinatorType: NSObjectProtocol {

    var baseController: UIViewController? { get }

    func start() throws

    func stop() throws

    func transition(to transition: Transition) throws

    func route(to route: Route)

}

public extension CoordinatorType {

    func stop() throws { }

}

public protocol Transition {

}

public protocol Route {

}
