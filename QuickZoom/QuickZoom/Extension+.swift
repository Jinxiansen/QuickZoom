//
//  Extension+.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Foundation

extension String {
    private static var digits = UnicodeScalar("0")..."9"
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
