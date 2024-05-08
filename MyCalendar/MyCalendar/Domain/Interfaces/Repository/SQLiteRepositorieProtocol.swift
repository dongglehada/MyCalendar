//
//  SQLiteRepositorieProtocol.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import Foundation

protocol SQLiteRepositorieProtocol {
    func createDB() -> OpaquePointer?
    func createTable()
    func deleteTable()
    func insertMemo(memo: Memo)
    func getMemo() -> [Memo]
    func updateMemo(memo: Memo)
    func deleteMemo(memo: Memo)
}
