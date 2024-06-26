//
//  Memo.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import Foundation

struct Memo: Codable {
    var id: Int32
    var updateDate: Date
    var calendarDate: Date?
    var title: String
    var memo: String
    var isPin: Bool
}
