//
//  AppDelegate.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Cocoa
import ServiceManagement

let launcherAppId = "com.null.quickZoomHelper"
extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    
    @IBOutlet weak var autoJoinItem: NSMenuItem!
    @IBOutlet weak var autoLoginItem: NSMenuItem!
    
    let clipboard = Clipboard()
    
    lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        return statusItem
    }()
    
    lazy var usageWindow: NSWindow = {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false)
        window.center()
        window.title = "How to use QuickZoom"
        window.contentViewController = NSStoryboard.loadController(UsageController.self)
        window.isReleasedWhenClosed = false
        return window
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        addMenuIconButton()
        configureMenuStatus()
        
        clipboard.startListening()
        clipboard.onNewCopy { stringValue in
            Analyzers.parse(string: stringValue)
        }
        menu.delegate = self

    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func autoJoinClick(_ sender: NSMenuItem) {
        AppStore.autoJoin.toggle()
        autoJoinItem.state = AppStore.autoJoin ? .on : .off
    }
    
    @IBAction func autoLoginClick(_ sender: NSMenuItem) {
        AppStore.autoLogin.toggle()
        autoLoginItem.state = AppStore.autoLogin ? .on : .off
        startupAppWhenLogin(startup: AppStore.autoLogin)
    }
    
    
    @IBAction func closeMenuClick(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func usageMenuClick(_ sender: NSMenuItem) {
        openUsageController()
    }
    
    @IBAction func aboutMenuClick(_ sender: NSMenuItem) {
        About.openAbout()
    }
    
}

extension AppDelegate {
    
    func configureMenuStatus() {
        autoJoinItem.state = AppStore.autoJoin ? .on : .off
        autoLoginItem.state = AppStore.autoLogin ? .on : .off
        startupAppWhenLogin(startup: AppStore.autoLogin)
    }
    
    func openUsageController() {
        NSApp.activate(ignoringOtherApps: true)
        usageWindow.makeKeyAndOrderFront(self)
    }
    
    func addMenuIconButton() {
        guard let button = statusItem.button else { return }
        button.image = NSImage(named: "statusIcon")
        button.action = #selector(mouseClickHandler)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    func startupAppWhenLogin(startup: Bool) {

        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty

        SMLoginItemSetEnabled(launcherAppId as CFString, startup)

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

