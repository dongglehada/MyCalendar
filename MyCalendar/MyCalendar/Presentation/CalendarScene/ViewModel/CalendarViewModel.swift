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
        var didSelectDate: Observable<Date>
        var viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        var loadToMemoDatas: Observable<[Memo]>
    }
    
    
    func transform(input: Input) -> Output {
        
        var memoDatas = input.viewWillAppear.map({ _ in
            self.getMemoToSQLiteUseCase.excute()
        }).asObservable()
        
        return Output(
            loadToMemoDatas: memoDatas
        )
    }
    
    let viewWillAppear = BehaviorRelay<Bool>(value: false)
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
    
    func isEventDay(date: Date) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let eventDays = getMemoToSQLiteUseCase.excute().map{
            dateFormatter.string(from: $0.updateDate)
        }
        
        return eventDays.contains(dateFormatter.string(from: date))
    }
    
    func isRunViewWillAppear(isRun: Bool) {
        viewWillAppear.accept(isRun)
    }
    
    func didSelectedDate(date: Date) {
        selectedDate.accept(date)
    }
}
