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
    
    // MARK: - Components
    
    private var calendar = CalendarView()
}

// MARK: - Life Cycle
extension CalendarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpUI()
    }
}

// MARK: - SetUp
private extension CalendarViewController {
    
    func setUp() {
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    func setUpUI() {
        view.addSubview(calendar)
        
        calendar.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        print(date)
        return 1
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [.getColor(color: .pointColor)]
    }
    
}

