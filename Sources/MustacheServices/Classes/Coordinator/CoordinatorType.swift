import UIKit

public protocol CoordinatorType: NSObjectProtocol {

    var baseController: UIViewController? { get }

    var parentCoordinator: (Transitionable & CoordinatorType)! { get set }
    var childCoordinators: [CoordinatorType] { get set }

    var services: ServicesType { get set }

    func start() throws

    func end()

}

extension CoordinatorType {

    public func end() {
        self.childCoordinators.forEach { type in type.end() }
        self.childCoordinators.removeAll()
    }
}

extension CoordinatorType where Self: Transitionable {

    public func addChildCoordinator(_ childCoordinator: CoordinatorType) {
        childCoordinator.parentCoordinator = self
        try! childCoordinator.start()
        self.childCoordinators.append(childCoordinator)

    }

    public func removeChildCoordinator(_ childCoordinator: CoordinatorType) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
        childCoordinator.end()
    }
}

public protocol Transition {
}

public extension Transition {
    mutating func update(model: Any) {}
}

public protocol Transitionable: NSObjectProtocol {

    func transition(to transition: Transition) throws

}
