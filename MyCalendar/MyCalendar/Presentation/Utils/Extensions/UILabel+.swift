//
//  UILabel+.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import UIKit

extension UILabel {
    func setLabel(font: UIFont, color: Colors) {
        self.textColor = UIColor.getColor(color: color)
        self.font = font
    }
}
