import Foundation

public protocol Service: NSObjectProtocol {

    init(services: Services) throws

    func clearState()
}

public protocol ServicesType {

    func add<S: Service>(service: S.Type) throws
    func get<S>() throws -> S

    func clearState()

}

public class Services: ServicesType {

    fileprivate var services: [Service.Type] = []
    fileprivate var initiated: [Service] = []

    public init() {}

    public func add<S: Service>(service: S.Type) throws {
        if services.contains(where: { existing -> Bool in
            return existing.self == S.self
        }) {
            throw ServicesTypeError.allReadyAdded(String(describing: S.self))
        }
        if initiated.contains(where: { existing -> Bool in
            return (existing as? S) != nil
        }) {
            throw ServicesTypeError.allReadyAdded(String(describing: S.self))
        }
        self.services.append(service)
    }

    public func add<S: Service>(service: S) throws {
        if services.contains(where: { existing -> Bool in
            return existing.self == S.self
        }) {
            throw ServicesTypeError.allReadyAdded(String(describing: S.self))
        }
        if initiated.contains(where: { existing -> Bool in
            return (existing as? S) != nil
        }) {
            throw ServicesTypeError.allReadyAdded(String(describing: S.self))
        }
        self.initiated.append(service)
    }

    public func get<S>() throws -> S {
        if let instance = self.initiated.first(where: { existing -> Bool in
            return (existing as? S) != nil
        }) {
            return instance as! S
        }
        guard let constructor = self.services.first(where: { existing -> Bool in
            return (existing as? S) != nil
        }) else {
            throw ServicesTypeError.notFound(String(describing: S.self))
        }

        let instance = try constructor.init(services: self) as! S

        self.initiated.append(instance as! Service)

        return instance
    }

    public func clearState() {
        self.initiated.forEach { service in service.clearState() }
    }
}

public enum ServicesTypeError: Error {

    case allReadyAdded(String)
    case notFound(String)

}
