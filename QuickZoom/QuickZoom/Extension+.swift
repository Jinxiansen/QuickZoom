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
        return String(unicodeScalars.filter(String.digits.contains))
    }
}
