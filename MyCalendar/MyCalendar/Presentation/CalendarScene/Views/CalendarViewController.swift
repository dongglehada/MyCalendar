//
//  CalendarViewController.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import UIKit

import FSCalendar
import SnapKit

class CalendarViewController: BasicController {
    
    var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.firstWeekday = 2
        calendar.scope = .month
        calendar.appearance.titleDefaultColor = .white
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(calendar)
        
        calendar.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
}

