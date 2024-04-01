//
//  Fonts.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import UIKit

enum Fonts {
    case sm
    case md
    case lg
    
    private var size: CGFloat {
        switch self {
        case .sm:
            return 14
        case .md:
            return 16
        case .lg:
            return 18
        }
    }
    
    var normalFont: UIFont {
        return UIFont.systemFont(ofSize: self.size)
    }
    
    var boldFont: UIFont {
        return UIFont.systemFont(ofSize: self.size, weight: .bold)
    }
}
