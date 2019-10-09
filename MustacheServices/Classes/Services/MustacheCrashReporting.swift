//
//  MustacheCrashReporting.swift
//  MustacheServices
//
//  Created by Tommy Hinrichsen on 09/10/2019.
//

import Foundation
import KSCrash

public class MustacheCrashReporting {

    public static let shared = MustacheCrashReporting()

    private let installation: KSCrashInstallationStandard

    private init(){
        self.installation = KSCrashInstallationStandard.sharedInstance()
        self.installation.url = URL(string: "https://mustache-services.herokuapp.com/api/v1/crashreporting")
        self.installation.install()

        KSCrash.sharedInstance()?.deleteBehaviorAfterSendAll = KSCDeleteOnSucess
        self.installation.sendAllReports { (reports, completed, error) -> Void in }
    }

}
