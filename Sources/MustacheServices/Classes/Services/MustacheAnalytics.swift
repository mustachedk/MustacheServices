// //
// //  MustacheAnalytics.swift
// //  MustacheServices
// //
// //  Created by Tommy Hinrichsen on 09/10/2019.
// //
//
// import Foundation
// import UIKit
//
// public class MustacheAnalytics {
//
//     fileprivate var version: String = "1"
//     fileprivate var uuidKey = "uuid"
//     fileprivate var defaults = UserDefaults(suiteName: "dk.mustache.analytics")
//
//     fileprivate var uuid: String {
//         get {
//             var uuid: String!
//             if let stored = self.defaults?.string(forKey: self.uuidKey) {
//                 uuid = stored
//             } else {
//                 uuid = UUID().uuidString
//                 self.defaults?.set(uuid, forKey: self.uuidKey)
//             }
//             return uuid
//         }
//     }
//
//     fileprivate lazy var dateFormatter: Formatter = {
//         let dateFormatter = ISO8601DateFormatter()
//         return dateFormatter
//     }()
//
//     public static let shared = MustacheAnalytics()
//
//     private init(){
//
//     }
//
//     public func track(screen: String?, controller: UIViewController) {
//         let screenName = screen ?? NSStringFromClass(type(of: controller))
//
//     }
//
//     public func track(event: String, parameters: [String: String]) {
//
//     }
//
//     public func track(error: Error, file: String = #file, function: String = #function, line: Int = #line ) {
//
//     }
//
//     fileprivate var eventInfo: [String: String] {
//
//         let info = [
//             "version": self.version,
//             "uuid": self.uuid,
//             "time": self.dateFormatter.string(for: Date()) ?? "",
//             "bundleIdentifier": Bundle.main.bundleIdentifier ?? "",
//             "CFBundleVersion" : Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "",
//             "CFBundleShortVersionString" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
//         ]
//         return info
//     }
//
//     fileprivate func createPayLoad() -> Encodable {
//
//     }
//
// }
//
// struct Event: Encodable {
//     var type: EventType
//
// }
//
// enum EventType: String, Codable {
//     case screen
//     case custom
//     case error
// }
