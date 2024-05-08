//
//  DefaultDeleteMemoToSQLiteUseCase.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 5/8/24.
//

import Foundation

class DefaultDeleteMemoToSQLiteUseCase: DeleteMemoToSQLiteUseCase {
    
    var repository: SQLiteRepositorieProtocol
    
    init(repository: SQLiteRepositorieProtocol) {
        self.repository = repository
    }
    
    func excute(memo: Memo) {
        repository.deleteMemo(memo: memo)
    }
}
