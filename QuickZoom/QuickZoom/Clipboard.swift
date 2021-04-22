//
//  Clipboard.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Cocoa
import Foundation

class Clipboard {
    typealias Hook = (String) -> Void

    private let pasteboard = NSPasteboard.general
    private let timerInterval = 1.0

    private var changeCount: Int
    private var hooks: [Hook]

    init() {
        changeCount = pasteboard.changeCount
        hooks = []
    }

    func onNewCopy(_ hook: @escaping Hook) {
        hooks.append(hook)
    }

    func startListening() {
        Timer.scheduledTimer(timeInterval: timerInterval,
                             target: self,
                             selector: #selector(checkForChangesInPasteboard),
                             userInfo: nil,
                             repeats: true)

        print("startListening")
    }

    func copyString(_ string: String) {
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(string, forType: NSPasteboard.PasteboardType.string)
    }

    @objc
    func checkForChangesInPasteboard() {
        guard pasteboard.changeCount != changeCount else {
            return
        }

        if let lastItem = pasteboard.string(forType: NSPasteboard.PasteboardType.string) {
            for hook in hooks {
                hook(lastItem)
            }
        }

        changeCount = pasteboard.changeCount
    }
}
