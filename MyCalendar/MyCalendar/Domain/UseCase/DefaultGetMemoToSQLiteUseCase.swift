//
//  DefaultGetMemoToSQLiteUseCase.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 5/8/24.
//

import Foundation

class DefaultGetMemoToSQLiteUseCase: GetMemoToSQLiteUseCase {
    var repository: SQLiteRepositorieProtocol
    
    init(repository: SQLiteRepositorieProtocol) {
        self.repository = repository
    }
    
    func excute() -> [Memo] {
        
        let sortedMemos = repository.getMemo().sorted { first, second in
            return first.updateDate > second.updateDate
        }
        
        let pinMemos = sortedMemos.filter({ $0.isPin })
        let normalMemos = sortedMemos.filter({ !$0.isPin })
        
        return pinMemos + normalMemos
    }
}
