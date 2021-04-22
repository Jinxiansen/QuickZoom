//
//  Alert.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/11.
//

import Cocoa
import Foundation

class Alert {
    static func showMessage(_ messsge: String) {
        let alert = NSAlert()
        alert.icon = NSImage(named: "icon")
        alert.messageText = messsge
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    static func showJoinMettingView(title: String, message: String) -> Bool {
        let alert = NSAlert()
        alert.icon = NSImage(named: "icon")
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Join")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
}
