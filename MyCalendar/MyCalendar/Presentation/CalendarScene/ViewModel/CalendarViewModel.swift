//
//  CalendarViewModel.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/10/24.
//

import Foundation

import RxSwift
import RxCocoa

class CalendarViewModel: ViewModelProtocol {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let selectedDate: Observable<Date>
        let viewWillAppear: ControlEvent<Void>
        let didTapMemoCell: Signal<IndexPath>
        let didTapNavigationAddButton: Signal<Void>
        let didTapNavigationEditButton: Signal<Void>
        let didDeleteMemo: Signal<IndexPath>
    }
    
    struct Output {
        let loadToMemoDatas: Observable<[Memo]>
        let moveToMemoAddVC: Signal<Void>
        let moveToMemoDetailVC: Observable<Memo>
        let changeEditMode: Signal<Void>
        let deleteMemo: Signal<IndexPath>
    }
    
    
    func transform(input: Input) -> Output {
        
        let getMemoDatas = input.selectedDate
            .withUnretained(self)
            .map({ (owner, date) in
                return owner.getMemo(date: date)
            })
            .asObservable()
        
        let selectedMemo = input.didTapMemoCell
            .withUnretained(self)
            .map { (owner, indexPath) in
                return owner.getMemo(date: owner.selectedDate.value)[indexPath.row]
            }
            .asObservable()
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.selectedDate.accept(owner.selectedDate.value)
            }.disposed(by: disposeBag)

        return Output(
            loadToMemoDatas: getMemoDatas,
            moveToMemoAddVC: input.didTapNavigationAddButton,
            moveToMemoDetailVC: selectedMemo,
            changeEditMode: input.didTapNavigationEditButton,
            deleteMemo: input.didDeleteMemo
        )
    }
    
    let selectedDate = BehaviorRelay<Date>(value: Date.now)
    
    // MARK: - Repository
    private let sqliteRepository: SQLiteRepositorieProtocol
    
    // MARK: - UseCase
    private let getMemoToSQLiteUseCase: GetMemoToSQLiteUseCase
    private let deleteMemoToSQLiteUseCase: DeleteMemoToSQLiteUseCase
    
    init(sqliteRepository: SQLiteRepositorieProtocol) {
        self.sqliteRepository = sqliteRepository
        self.getMemoToSQLiteUseCase = DefaultGetMemoToSQLiteUseCase(repository: sqliteRepository)
        self.deleteMemoToSQLiteUseCase = DefaultDeleteMemoToSQLiteUseCase(repository: sqliteRepository)
    }
    
    func getMemo() -> [Memo] {
        return getMemoToSQLiteUseCase.excute()
    }
    
    func getMemo(date: Date) -> [Memo] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return self.getMemo().filter({$0.calendarDate != nil}).filter({formatter.string(from: $0.calendarDate!) == formatter.string(from: date)})
    }
    
    func isEventDay(date: Date) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let eventDays = getMemoToSQLiteUseCase.excute()
            .compactMap({
                $0.calendarDate
            }).map({
                dateFormatter.string(from: $0)
            })
        
        return eventDays.contains(dateFormatter.string(from: date))
    }
    
    func didSelectedDate(date: Date) {
        selectedDate.accept(date)
    }
    
    func deleteMemo(memo: Memo) {
        deleteMemoToSQLiteUseCase.excute(memo: memo)
    }
}
