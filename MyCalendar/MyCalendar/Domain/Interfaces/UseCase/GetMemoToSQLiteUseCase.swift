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


