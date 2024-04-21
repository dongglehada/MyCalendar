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

    private var disposeBag = DisposeBag()
    
    // MARK: - Components
    
    private var calendar = CalendarView()
    
    private var memoTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        return view
    }()
    
    private var memoAddButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitleColor(.getColor(color: .pointColor), for: .normal)
        return button
    }()
    
    private var memoEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.setTitleColor(.getColor(color: .pointColor), for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        return button
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
        setUpBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.reloadData()
    }
}

// MARK: - SetUp
private extension CalendarViewController {
    
    func setUp() {
        calendar.delegate = self
        calendar.dataSource = self
        memoTableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
        
        let emptyButton = UIBarButtonItem()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: memoAddButton),
            emptyButton,
            UIBarButtonItem(customView: memoEditButton)
        ]
        navigationController?.navigationBar.tintColor = .getColor(color: .pointColor)
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
        let input = CalendarViewModel.Input(
            selectedDate: viewModel.selectedDate.asObservable(),
            viewWillAppear: self.rx.viewWillAppear,
            didTapMemoCell: memoTableView.rx.itemSelected.asSignal(),
            didTapNavigationAddButton: memoAddButton.rx.tap.asSignal(),
            didTapNavigationEditButton: memoEditButton.rx.tap.asSignal(),
            didDeleteMemo: memoTableView.rx.itemDeleted.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.loadToMemoDatas
            .bind(to: memoTableView.rx.items(cellIdentifier: MemoListTableViewCell.identifier)) { (index: Int, element: Memo, cell: MemoListTableViewCell) in
                cell.bind(memo: element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.moveToMemoDetailVC
            .withUnretained(self)
            .subscribe { (owner, memo) in
                let vm = MemoDetailViewModel(sqlLiteRepository: SQLiteRepositorie.shared)
                vm.displayMemo(memo: memo)
                let vc = MemoDetailViewController(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.moveToMemoAddVC
            .emit { [weak self] _ in
                guard let self = self else { return }
                let viewModel = MemoDetailViewModel(sqlLiteRepository: SQLiteRepositorie.shared)
                viewModel.setCalendarDate(date: calendar.selectedDate)
                self.navigationController?.pushViewController(MemoDetailViewController(viewModel: viewModel), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.changeEditMode
            .emit { [weak self] _ in
                guard let self = self else { return }
                let isEditing = !self.memoTableView.isEditing
                self.memoTableView.setEditing(isEditing, animated: true)
                self.memoEditButton.setImage(isEditing ? UIImage(systemName: "checkmark") : UIImage(systemName: "trash"), for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.deleteMemo
            .emit { [weak self] indexPath in
                guard let self = self else { return }
                guard let date = self.calendar.selectedDate else { return }
                let memo = viewModel.getMemo(date: date)[indexPath.row]
                self.viewModel.deleteMemo(memo: memo)
                self.viewWillAppear(true)
            }
            .disposed(by: disposeBag)
        
    }
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.isEventDay(date: date) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [.getColor(color: .pointColor)]
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.didSelectedDate(date: date)
    }
}
