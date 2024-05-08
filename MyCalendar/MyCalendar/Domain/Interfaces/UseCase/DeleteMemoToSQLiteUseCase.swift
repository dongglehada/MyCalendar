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


