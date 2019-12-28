//
//  File.swift
//  
//
//  Created by Tommy Sadiq Hinrichsen on 28/12/2019.
//

import Foundation
import Resolver

extension Resolver {
    
    public static func registerMustacheServices() {
        self.registerNetworkServices()
        self.registerGeoLocationServices()
        self.registerNotificationServices()
        self.registerDawaServices()
    }
    
    public static func registerNetworkServices() {
        Resolver.register(CredentialsServiceType.self) { CredentialsService() }
        Resolver.register(NetworkServiceType.self) { NetworkService() }
    }
    
    public static func registerGeoLocationServices() {
        Resolver.register(GeoLocationServiceType.self) { GeoLocationService() }
    }
    
    public static func registerNotificationServices() {
        Resolver.register(NotificationServiceType.self) { NotificationService() }
    }
    
    public static func registerDawaServices() {
        Resolver.register(DAWAServiceType.self) { DAWAService() }
    }
}


