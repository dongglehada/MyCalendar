//
//  SQLiteDateUpdateUseCase.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/2/24.
//

import Foundation

protocol UpdateMemoToSQLiteUseCase {
    var repository: SQLiteRepositorieProtocol { get set }
    func excute(memo:Memo)
}

class DefaultUpdateMemoToSQLiteUseCase: UpdateMemoToSQLiteUseCase {
    
    var repository: SQLiteRepositorieProtocol
    
    init(repository: SQLiteRepositorieProtocol) {
        self.repository = repository
    }
    
    func excute(memo: Memo) {
        if repository.getMemo().map({$0.id}).contains(memo.id) {
            repository.updateMemo(memo: memo)
        } else {
            repository.insertMemo(memo: memo)
        }
    }
}
