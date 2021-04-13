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
        
        launchService()
        
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

    
    func launchService() {
        
        let mainAppIdentifier = "com.null.quickZoom"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty
        
        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: .killLauncher, object: mainAppIdentifier)
            
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("MainApplication") //main app name
            
            let newPath = NSString.path(withComponents: components)
            
            NSWorkspace.shared.launchApplication(newPath)
        }
        else {
            self.terminate()
        }
        
    }
    
    @objc func terminate() {
        NSApp.terminate(nil)
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

