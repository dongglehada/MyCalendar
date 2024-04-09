//
//  CalendarView.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/10/24.
//

import Foundation

import FSCalendar

class CalendarView: FSCalendar {
    
    init() {
        super.init(frame: .zero)
        self.locale = Locale(identifier: "ko_KR") // 언어 설정
        self.appearance.headerTitleColor = .getColor(color: .pointColor) // Header 폰트 색상
        self.appearance.weekdayTextColor = .getColor(color: .pointColor) // 요일 색상
        self.appearance.selectionColor = .getColor(color: .pointColor) // 선택 색상
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
