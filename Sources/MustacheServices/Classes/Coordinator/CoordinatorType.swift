import UIKit

// https://medium.com/concretelatinoamérica/inverse-reference-coordinator-pattern-d5a5948c0d90
public protocol CoordinatorType: NSObjectProtocol {

    /// Should be a weak property to prevent memory leaks
    var rootController: UIViewController? { get }

    var parentCoordinator: CoordinatorType! { get set }
    
    init(parent: CoordinatorType) 
    
    func start() throws
    
    func stop() throws

    func transition(to transition: Transition) throws


}

extension CoordinatorType {
    
    func stop() throws { }
    
}

public protocol Transition {

}
