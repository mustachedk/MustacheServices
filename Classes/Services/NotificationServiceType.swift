//
// Created by Tommy Sadiq Hinrichsen on 2019-02-01.
// Copyright (c) 2019 Mustache ApS. All rights reserved.
//

import Foundation
import UserNotifications

public protocol NotificationServiceType: Service {

    func registerForPushNotifications(completionHandler: @escaping (Bool, Error?) -> Void)

}

public final class NotificationService: NSObject, NotificationServiceType, UNUserNotificationCenterDelegate {

    public required init(services: Services) throws {}

    public func registerForPushNotifications(completionHandler: @escaping (Bool, Error?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            if granted { self?.getNotificationSettings() }
            completionHandler(granted, error)
        }
    }


    fileprivate func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    public func clearState() {}
}

