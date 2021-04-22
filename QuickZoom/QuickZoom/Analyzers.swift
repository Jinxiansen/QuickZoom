//
//  Analyzers.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Cocoa
import Foundation

class Analyzers {
    static func parse(string: String) {
        guard !string.isEmpty else { return }
        let rows = string.components(separatedBy: .newlines).filter { !$0.isEmpty }
        print("OriginString: \n\(string)\n")
        var isOpened = false
        for (index, row) in rows.enumerated() {
            if row.contains("https://"), row.contains("zoom.") {
                // https://zoom.us/j/3211233218
                // https://xxx.zoom.com.cn/j/3211233218?pwd=jaYeQt-YmAITGr0D3MRTsTm6M531L2vT
                let result = row.components(separatedBy: "?pwd=")
                if result.count == 2,
                   let mettingID = result.first?.components(separatedBy: "/").last,
                   !mettingID.isEmpty,
                   let password = result.last,
                   !password.isEmpty, !isOpened
                {
                    openZoom(meetingID: mettingID, password: password)
                    isOpened.toggle()
                    return
                }

                // https://xxx.zoom.com.cn/j/3759079899 (Passcode: 682782330)
                supportLanguages.forEach {
                    let separator = "(\($0.value):"
                    let result = row.removeSpace.replaceChineseColon.replaceBracket.components(separatedBy: separator)
                    if result.count == 2 {
                        if let mettingID = result.first?.components(separatedBy: "/").last,
                           !mettingID.isEmpty,
                           let password = result.last?.removeRightBracket,
                           !password.isEmpty, !isOpened
                        {
                            openZoom(meetingID: mettingID, password: password)
                            isOpened.toggle()
                            return
                        }
                    }
                }
            }

            if index > 0 {
                /*
                 Meeting ID: 959 1701 1534
                 Passcode: 744594240
                 */
                supportLanguages.forEach {
                    if row.contains($0.value), rows[index - 1].contains($0.key) {
                        let meetingID = rows[index - 1].replaceChineseColon.components(separatedBy: "\($0.key):").last?.removeSpace
                        let password = row.replaceChineseColon.components(separatedBy: "\($0.value):").last?.removeSpace
                        if let meetingID = meetingID, let password = password, !isOpened {
                            openZoom(meetingID: meetingID, password: password)
                            isOpened.toggle()
                            return
                        }
                    }
                }
            }
        }
    }

    static func openZoom(meetingID: String, password: String) {
        guard let url = URL(string: "zoommtg://zoom.us/join?confno=\(meetingID)&pwd=\(password)") else {
            print("URL Error")
            return
        }

        if AppStore.autoJoin {
            openZoom(url: url)
        } else {
            let title = "Do you want to join this meeting?"
            let message = "Metting ID: \(meetingID)\nPassword: \(password)\n"
            let result = Alert.showJoinMettingView(title: title, message: message)
            if result {
                openZoom(url: url)
            }
        }
    }

    private static func openZoom(url: URL) {
        let result = NSWorkspace.shared.open(url)
        print("Open Result: \(result), URL: \(url)")
        if !result {
            Alert.showMessage("Please install zoom and try again.")
        }
    }
}
