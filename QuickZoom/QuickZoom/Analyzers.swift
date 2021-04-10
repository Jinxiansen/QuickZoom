//
//  Analyzers.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Foundation
import Cocoa

class Analyzers {
    
    static func parse(string: String) {
        guard !string.isEmpty else { return }
        let rows = string.components(separatedBy: .newlines)
        
        for (index, row) in rows.enumerated() {
            guard index > 0 else { continue }
            let value = row.digits
            guard !value.isEmpty else {
                //                print("continue: \(value)")
                continue
            }
            print("value: \(value)")
            
            let lastValue = rows[index - 1].digits
            guard lastValue.count > 5 && value.count > 5 else {
                continue
            }
            
            let mettingID = lastValue
            let password = value
            
            openZoom(meetingID: mettingID, password: password)
            break
        }
    }
    
    static func openZoom(meetingID: String, password: String) {
        
        
        guard let url = URL(string: "zoommtg://zoom.us/join?confno=\(meetingID)&pwd=\(password)") else {
            print("URL Error")
            return
        }
        
        let result = NSWorkspace.shared.open(url)
        if result {
            showTitle("Please install zoom and try again.")
        }
    }
    
    private static func showTitle(_ title: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
