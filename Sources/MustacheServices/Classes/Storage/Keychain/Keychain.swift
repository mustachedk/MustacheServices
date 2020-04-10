//
//  Keychain.swift
//  userapp
//
//  Created by Tommy Sadiq Hinrichsen on 05/04/2020.
//  Copyright © 2020 Tommy Sadiq Hinrichsen. All rights reserved.
//

import Foundation
import MustacheServices

@propertyWrapper
class Keychain<Value: Codable> {
    
    fileprivate var key: String
    fileprivate var defaultValue: Value
    
    init(_ key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    open var wrappedValue: Value {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: self.key) else { return self.defaultValue }
            guard let value = try? JSONDecoder().decode(Value.self, from: data) else { return self.defaultValue }
            return value
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                KeychainWrapper.standard.removeObject(forKey: self.key)
                return
            }
            KeychainWrapper.standard.set(data, forKey: self.key)
        }
    }
}

@propertyWrapper
open class KeychainOptional<Value: Codable> {
    
    fileprivate var key: String
    
    public  init(_ key: String) {
        self.key = key
    }
    
    open var wrappedValue: Value? {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: self.key) else { return nil }
            guard let value = try? JSONDecoder().decode(Value.self, from: data) else { return nil }
            return value
        }
        set {
            guard let value = newValue else {
                KeychainWrapper.standard.removeObject(forKey: self.key)
                return
            }
            guard let data = try? JSONEncoder().encode(value) else {
                KeychainWrapper.standard.removeObject(forKey: self.key)
                return
            }
            KeychainWrapper.standard.set(data, forKey: self.key)
        }
    }
}
