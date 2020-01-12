import UIKit

// https://medium.com/concretelatinoamérica/inverse-reference-coordinator-pattern-d5a5948c0d90
public protocol CoordinatorType: NSObjectProtocol {

    func start() throws
    
    func stop() throws

    func transition(to transition: Transition) throws


}

public extension CoordinatorType {
    
    func stop() throws { }
    
}

public protocol Transition {

}
