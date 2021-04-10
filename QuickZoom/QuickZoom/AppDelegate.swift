//
//  AppDelegate.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  
    @IBOutlet weak var menu: NSMenu!
    
    @IBOutlet weak var autoJoinMenuItem: NSMenuItem!
    
    let popover = NSPopover()
    let clipboard = Clipboard()
    var eventMonitor: EventMonitor?
    
    lazy var statusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        return statusItem
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        addMenuIconButton()
        autoJoinMenuItem.state = AppStore.autoJoin ? .on : .off
        
        clipboard.startListening()
        clipboard.onNewCopy { stringValue in
            if AppStore.autoJoin {
                Analyzers.parse(string: stringValue)
            }
        }
        menu.delegate = self
        popover.contentViewController = PopoverController.freshController()
        
        setupEventMonitor()
        
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
    
    func setupEventMonitor() {
//        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
//            guard let self = self else { return }
//            if self.popover.isShown {
//                self.closePopover(event!)
//            }
//        }
    }
}

extension AppDelegate: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        print("Will open.")
//        autoJoinMenuItem.title = "Auto Join"
    }
    
    func menuDidClose(_ menu: NSMenu) {
        self.statusItem.menu = nil
    }
}

extension AppDelegate {
    
    @objc func mouseClickHandler() {
//        if let event = NSApp.currentEvent {
//            switch event.type {
//            case .leftMouseUp:
//                togglePopover(popover)
//            default:
                statusItem.menu = menu
                statusItem.button?.performClick(nil)
//            }
//        }
    }
    
//    @objc func togglePopover(_ sender: AnyObject) {
//        if popover.isShown {
//            closePopover(sender)
//        } else {
//            showPopover(sender)
//        }
//    }
//
//    @objc func showPopover(_ sender: AnyObject) {
//        if let button = statusItem.button {
//            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
//        }
//        eventMonitor?.start()
//
//    }
//
//    @objc func closePopover(_ sender: AnyObject) {
//        popover.performClose(sender)
//        eventMonitor?.stop()
//    }
}

