//
//  MemoListViewModel.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import Foundation

import RxSwift
import RxCocoa

class MemoListViewModel: ViewModelProtocol {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    // MARK: - Properties
    
    private let memoDatas = BehaviorRelay<[Memo]>(value: [])

    
    // MARK: - Repository
    private let sqlLiteRepository: SQLiteRepositorieProtocol
    
    init(sqlLiteRepository: SQLiteRepositorieProtocol) {
        self.sqlLiteRepository = sqlLiteRepository
    }
}
