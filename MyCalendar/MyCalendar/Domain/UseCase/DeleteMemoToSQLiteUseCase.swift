//
//  DeleteMemoToSQLiteUseCase.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/3/24.
//

import Foundation

protocol DeleteMemoToSQLiteUseCase {
    var repository: SQLiteRepositorieProtocol { get set }
    func excute(memo:Memo)
}

class DefaultDeleteMemoToSQLiteUseCase: DeleteMemoToSQLiteUseCase {
    
    var repository: SQLiteRepositorieProtocol
    
    init(repository: SQLiteRepositorieProtocol) {
        self.repository = repository
    }
    
    func excute(memo: Memo) {
        repository.deleteMemo(memo: memo)
    }
}
