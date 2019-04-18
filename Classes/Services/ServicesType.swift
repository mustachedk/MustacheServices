//
// Created by Tommy Hinrichsen on 14/09/2018.
// Copyright (c) 2018 Mustache ApS. All rights reserved.
//

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
        if services.contains(where: { existing -> Bool in return existing == service }) { throw ServicesTypeError.allReadyAdded(String(describing: S.self)) }
        services.append(service)
    }

    public func get<S>() throws -> S {
        if let instance = initiated.first(where: { existing -> Bool in return existing is S }) {
            return instance as! S
        }
        guard let constructor = services.first(where: { existing -> Bool in return existing is S }) else {
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
