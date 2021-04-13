//
//  AppDelegate.swift
//  QuickZoomHelper
//
//  Created by 晋先森 on 2021/4/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        startupAppWhenLogin()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

extension AppDelegate {
    
    func startupAppWhenLogin() {

        let launcherAppId = "com.null.quickZoomHelper"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty

        SMLoginItemSetEnabled(launcherAppId as CFString, true)

        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
        }
    }
}
