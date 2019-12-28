import UIKit

public protocol CoordinatorType: NSObjectProtocol {

    var rootController: UIViewController? { get }

    var parentCoordinator: CoordinatorType? { get set }
    
    func start() throws

    func transition(to transition: Transition) throws


}

public protocol Transition {

}
