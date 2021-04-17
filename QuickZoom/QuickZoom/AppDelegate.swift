//
//  AppDelegate.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Cocoa
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    
    @IBOutlet weak var autoJoinMenuItem: NSMenuItem!
    
    let clipboard = Clipboard()
    
    lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        return statusItem
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        addMenuIconButton()
        autoJoinMenuItem.state = AppStore.autoJoin ? .on : .off
        
        clipboard.startListening()
        clipboard.onNewCopy { stringValue in
            Analyzers.parse(string: stringValue)
        }
        menu.delegate = self
        
        startupAppWhenLogin()
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func autoJoinClick(_ sender: NSMenuItem) {
        AppStore.autoJoin.toggle()
        autoJoinMenuItem.state = AppStore.autoJoin ? .on : .off
    }
    
    @IBAction func closeMenuClick(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func aboutMenuClick(_ sender: NSMenuItem) {
        About.openAbout()
    }
    
}

extension AppDelegate {
    
    func addMenuIconButton() {
        guard let button = statusItem.button else { return }
        button.image = NSImage(named: "statusIcon")
        button.action = #selector(mouseClickHandler)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

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

extension AppDelegate: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        // print("Will open.")
    }
    
    func menuDidClose(_ menu: NSMenu) {
        self.statusItem.menu = nil
    }
}

extension AppDelegate {
    
    @objc func mouseClickHandler() {
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
    }
}

