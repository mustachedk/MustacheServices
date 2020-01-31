
import Foundation
import UserNotifications
import UIKit

public protocol NotificationServiceType: class {

    func registerForPushNotifications(completionHandler: @escaping (Bool, Error?) -> Void)

}

public final class NotificationService: NSObject, NotificationServiceType, UNUserNotificationCenterDelegate {

    public override init() {
        super.init()
    }

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

}
