//
//  Extension+.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Cocoa
import Foundation

extension String {
    private static var digits = UnicodeScalar("0") ... "9"
    var digits: String {
        String(unicodeScalars.filter(String.digits.contains))
    }

    var replaceChineseColon: Self {
        replacingOccurrences(of: "：", with: ":")
    }

    var replaceBracket: Self {
        replacingOccurrences(of: "（", with: "(").replacingOccurrences(of: "）", with: ")")
    }

    var removeRightBracket: Self {
        replacingOccurrences(of: ")", with: "")
    }

    var removeSpace: Self {
        replacingOccurrences(of: " ", with: "")
    }
}

extension NSStoryboard {
    static func loadController<T: NSViewController>(_ controller: T.Type) -> T {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(String(describing: controller))
        guard let controller = storyboard.instantiateController(withIdentifier: identifier) as? T else {
            fatalError("Something Wrong with Main.storyboard")
        }
        return controller
    }
}
