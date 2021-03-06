//
//  AppDelegate.swift
//  QuickZoomHelper
//
//  Created by 晋先森 on 2021/4/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        launchService()
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }
}

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

extension AppDelegate {
    func launchService() {
        let mainAppIdentifier = "com.null.quickZoom"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty

        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(terminate), name: .killLauncher, object: mainAppIdentifier)

            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("QuickZoom") // main app name

            let newPath = NSString.path(withComponents: components)
            NSWorkspace.shared.launchApplication(newPath)
        } else {
            terminate()
        }
    }

    @objc func terminate() {
        NSApp.terminate(nil)
    }
}
