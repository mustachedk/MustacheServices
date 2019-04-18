//
// Created by Tommy Sadiq Hinrichsen on 2019-02-01.
// Copyright (c) 2019 Mustache ApS. All rights reserved.
//

import Foundation
import UserNotifications

#if MustacheRx
import RxSwift
#endif

protocol NotificationServiceType: Service {

    func registerForPushNotifications(completionHandler: @escaping (Bool, Error?) -> Void)

    #if MustacheRx

    func registerForPushNotifications() -> Observable<Bool>

    #endif

}

final class NotificationService: NSObject, NotificationServiceType, UNUserNotificationCenterDelegate {

    required init(services: Services) throws {}

    #if MustacheRx

    func registerForPushNotifications() -> Observable<Bool> {
        return Observable<Bool>.create { (observer) in
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if let error = error {
                            observer.onError(error)
                        } else {
                            observer.onNext(granted)
                            observer.onCompleted()
                        }
                    }
                    return Disposables.create()
                }
                .do(onNext: { [weak self] granted in
                    if granted { self?.getNotificationSettings() }
                })
    }

    #endif

    func registerForPushNotifications(completionHandler: @escaping (Bool, Error?) -> Void) {
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

    func clearState() {}
}

