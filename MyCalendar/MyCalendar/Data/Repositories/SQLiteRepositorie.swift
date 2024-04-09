//
//  SQLiteRepositorie.swift
//  MyCalendar
//
//  Created by SeoJunYoung on 4/1/24.
//

import Foundation

import SQLite3

class SQLiteRepositorie: SQLiteRepositorieProtocol {
    
    var db: OpaquePointer?
    var path = "mySqlite.sqlite"
    
    init() {
        self.db = createDB()
        createTable()
        print(self, "init")
    }
    
    func createDB() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
            if sqlite3_open(filePath.path, &db) == SQLITE_OK {
                print("Success create db Path")
                return db
            }
        }
        catch {
            print("error in createDB")
        }
        print("error in createDB - sqlite3_open")
        return nil
    }
    
    func createTable() {
        let query = "create table if not exists myDB (id INTEGER primary key autoincrement, memo text)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("create table success")
            } else {
                print("create table step fail")
            }
        } else {
            print("error: create table sqlite3 prepare fail")
        }
        sqlite3_finalize(statement)
    }
    
    func deleteTable() {
        let query = "DROP TABLE myDB"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete table success")
            } else {
                print("delete table step fail")
            }
        } else {
            print("delete table prepare fail")
        }
    }
    
    func insertMemo(memo: Memo) {
        let query = "insert into myDB (id, memo) values (?,?)"
        var statement: OpaquePointer? = nil
        do {
            let data = try JSONEncoder().encode(memo)
            let dataToString = String(data: data, encoding: .utf8)
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 2, NSString(string: dataToString!).utf8String, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("insert data success")
                } else {
                    print("insert data sqlite3 step fail")
                }
                
            } else {
                print("insert Data prepare fail")
            }
            sqlite3_finalize(statement)
        }
        catch {
            print("JsonEncoder Error")
        }
    }
    
    func getData() -> [Memo] {
        let query = "select * from myDB"
        var statement: OpaquePointer? = nil
        var result: [Memo] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let memoData = String(cString: sqlite3_column_text(statement, 1))
                do {
                    var data = try JSONDecoder().decode(Memo.self, from: memoData.data(using: .utf8)!)
                    data.id = id
                    result.append(data)
                } catch {
                    print("JSONDecoder Error")
                }
            }
        } else {
            print("read Data prepare fail")
        }
        sqlite3_finalize(statement)
        return result
    }

    func updateMemo(memo: Memo) {
        do {
            let data = try JSONEncoder().encode(memo)
            guard let dataToString = String(data: data, encoding: .utf8) else { return }
            let query = "update myDB set memo = '\(dataToString)' where id = \(memo.id)"
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("success updateData")
                } else {
                    print("updataData sqlite3 step fail")
                }
            } else {
                print("updateData prepare fail")
            }
        } catch {
            print("JSONDecoder Error")
        }
    }

    
    func deleteMemo(memo: Memo) {
        let query = "delete from myDB where id = \(memo.id)"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete data success")
            } else {
                print("delete data step fail")
            }
        } else {
            print("delete data prepare fail")
        }
        sqlite3_finalize(statement)
    }
}
