//
//  GetMemoToSQLiteUseCase.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/2/24.
//

import Foundation

protocol GetMemoToSQLiteUseCase {
    var repository: SQLiteRepositorieProtocol { get set }
    func excute() -> [Memo]
}

class DefaultGetMemoToSQLiteUseCase: GetMemoToSQLiteUseCase {
    var repository: SQLiteRepositorieProtocol
    
    init(repository: SQLiteRepositorieProtocol) {
        self.repository = repository
    }
    
    func excute() -> [Memo] {
        
        let sortedMemos = repository.getData().sorted { first, second in
            return first.updateDate > second.updateDate
        }
        
        let pinMemos = sortedMemos.filter({ $0.isPin })
        let normalMemos = sortedMemos.filter({ !$0.isPin })
        
        return pinMemos + normalMemos
    }
}
