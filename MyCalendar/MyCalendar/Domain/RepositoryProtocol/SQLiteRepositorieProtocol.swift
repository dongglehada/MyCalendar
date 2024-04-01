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
    func insertData(memo: Memo)
    func getData() -> [Memo]
    func updateData(memo: Memo)
    func deleteData(id: UUID)
}
