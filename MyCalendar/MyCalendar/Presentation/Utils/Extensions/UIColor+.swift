//
//  UIColor+.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import UIKit

extension UIColor {
    static func getColor(color: Colors) -> UIColor {
        switch color {
        case .pointColor:
            return UIColor.systemMint
        case .black:
            return UIColor.black
        case .gray:
            return UIColor.systemGray4
        }
    }
}
