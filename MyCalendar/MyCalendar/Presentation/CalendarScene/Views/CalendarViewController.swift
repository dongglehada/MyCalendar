//
//  CalendarViewController.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import UIKit

import FSCalendar
import SnapKit

import RxSwift
import RxCocoa

class CalendarViewController: BasicController {
    
    // MARK: - Properties
    
    private var viewModel: CalendarViewModel

    
    // MARK: - Components
    
    private var calendar = CalendarView()
    
    private var memoTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension CalendarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.isRunViewWillAppear(isRun: true)
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
        view.addSubview(memoTableView)
        
        calendar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Constants.screenHeight / 2)
        }
        
        memoTableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setUpBind() {
        var input = CalendarViewModel.Input(
            didSelectDate: viewModel.selectedDate.asObservable(),
            viewWillAppear: viewModel.viewWillAppear.asObservable()
        )
    }
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.isEventDay(date: date) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [.getColor(color: .pointColor)]
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.didSelectedDate(date: date)
    }
    
}

