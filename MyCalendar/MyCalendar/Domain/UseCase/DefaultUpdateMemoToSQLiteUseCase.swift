//
//  DefaultUpdateMemoToSQLiteUseCase.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 5/8/24.
//

import Foundation

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
