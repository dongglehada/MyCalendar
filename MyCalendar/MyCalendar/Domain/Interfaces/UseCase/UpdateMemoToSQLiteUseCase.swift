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


