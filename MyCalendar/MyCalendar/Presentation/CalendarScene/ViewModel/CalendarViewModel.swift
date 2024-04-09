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
        
    }
    
    struct Output {
        
    }
    
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
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
}
