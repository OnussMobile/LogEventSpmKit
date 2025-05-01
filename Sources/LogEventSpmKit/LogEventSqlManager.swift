//
//  LogSqlManager.swift
//  LogEventSpmKit
//
//  Created by Mustafa Alper Aydin on 29.04.2025.
//

import Foundation
import SQLite

public protocol DatabaseProviderLogEvent {
    var databaseLogEvent: Connection? { get }
}

public class DatabaseServiceLogEvent {
    public static var providerLogEvent: DatabaseProviderLogEvent?

    public static func getDatabaseLogEvent() -> Connection? {
        return providerLogEvent?.databaseLogEvent
    }
}

public class LogEventSqlManager {
    
    public static let logTable = Table("LogHistoryTable")
        
    public static let id = Expression<UUID>("logId")
    public static let pageType = Expression<String>("logPageType")
    public static let mxRoute = Expression<Int>("logMxRoute")
    public static let mxBlock = Expression<Int>("logMxBlock")
    public static let type = Expression<Int>("logType") // LogHistoryType rawValue
    public static let logId = Expression<String>("logLogId") // LogHistoryId rawValue
    public static let desc = Expression<String>("logDesc")
    public static let count = Expression<Int>("logCount")
    public static let degress = Expression<Int>("logDegress") // LogHistoryDegress rawValue
    public static let source = Expression<Int>("logSource") // LogHistorySource rawValue
    public static let comment = Expression<String>("logComment")
    
    public static func createTable(){
        createSqlEntityTable()
        createUserEventTable()
    }
    
    public static func createSqlEntityTable() {
        guard let database = DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return
        }
        do {
            //ifNotExists: true Will NOT create a table if it already exists
            try database.run(logTable.create(ifNotExists: true) { table in
                table.column(id)
                table.column(pageType)
                table.column(mxRoute)
                table.column(mxBlock)
                table.column(type)
                table.column(logId)
                table.column(desc)
                table.column(count)
                table.column(degress)
                table.column(source)
                table.column(comment)
            })
        }catch {
            print("createSqlEntityTable already exists: \(error)")
        }
    }
    
    public static func insertLogHistory(_ contactValues: LogHistoryModel) -> Bool? {
        guard let database = DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return nil
        }

        do {
            try database.run(logTable.insert(
                pageType <- contactValues.LogHistoryPageType,
                mxRoute <- contactValues.LogHistoryMxRoute,
                mxBlock <- contactValues.LogHistoryMxBlock,
                type <- contactValues.LogHistoryType.rawValue,
                logId <- contactValues.LogHistoryId.rawValue,
                desc <- contactValues.LogHistoryDesc,
                count <- contactValues.LogHistoryCount,
                degress <- contactValues.LogHistoryDegress.rawValue,
                source <- contactValues.LogHistorySource.rawValue,
                comment <- contactValues.LogHistoryComment
            ))
            return true
        } catch let error {
            // Bu kısmı da SPM'de tanımlıysa çağırabilirsiniz
            print("Inserting LogHistory failed: \(error)")
            return false
        }
    }
    
    public static func getLogHistoryModelArray() -> [LogHistoryModel]? {
        guard let database = DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return nil
        }
        
        var logHistoryArray : [LogHistoryModel] = []
        
        do {
            
            for point in try database.prepare(logTable) {
                let LogHistoryPageType = point[pageType]
                let LogHistoryMxRoute = point[mxRoute]
                let LogHistoryMxBlock = point[mxBlock]
                let LogHistoryType = LogHistoryType(rawValue: point[type]) ?? .historyTypeNull
                let LogHistoryId = LogHistoryId(rawValue: point[logId])
                let LogHistoryDesc = point[desc]
                let LogHistoryCount = point[count]
                let LogHistoryDegress = LogHistoryDegress(rawValue: point[degress]) ?? .onemsiz
                let LogHistorySource = LogHistorySource(rawValue: point[source]) ?? .mbl
                let LogHistoryComment = point[comment]
                
                logHistoryArray.append(LogHistoryModel(LogHistoryPageType: LogHistoryPageType, LogHistoryMxRoute: LogHistoryMxRoute, LogHistoryMxBlock: LogHistoryMxBlock, LogHistoryType: LogHistoryType, LogHistoryId: LogHistoryId, LogHistoryDesc: LogHistoryDesc, LogHistoryCount: LogHistoryCount, LogHistoryDegress: LogHistoryDegress, LogHistorySource: LogHistorySource, LogHistoryComment: LogHistoryComment))
                
            }
        } catch{
            print("getLogHistoryModelArray error")
            return nil
        }
        return logHistoryArray
        
    }
    
    public static func updateLogHistoryCount(logHistoryId: LogHistoryId, desci: String = "") -> Bool? {
        guard let database = DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return nil
        }
        
        let point = logTable.filter(logId == logHistoryId.rawValue)
        
        do {
            // Önce mevcut veriyi çekiyoruz
            if let existingRow = try database.pluck(point) {
                let currentCount = existingRow[count]
                let currentDesc = existingRow[desc]
                let newDesc = currentDesc + (desci.isEmpty ? "" : "\n\(desci)")
                
                // Güncelleme işlemi
                if try database.run(point.update(
                    count <- currentCount + 1,
                    desc <- newDesc
                )) > 0 {
                    print("Updated Point Status1")
                    return true
                } else {
                    print("Could not update Point Status")
                    return false
                }
            } else {
                print("No matching row found")
                return false
            }
        } catch let error {
            print("Updating failed \(error)")
            return false
        }
    }
    
    public static func deleteLogHistoryTable() -> Bool? {
        guard let database =
                DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            try database.run(logTable.delete())
            
            return true
        } catch let error {
            print("delete Table: \(error)")
            return false
        }
    }
    
    public static var userEventTable = Table("userEventTable")
    
    public static let eventMxRoute = Expression<Int>("userEventMxRoute")
    public static let eventMxBlock = Expression<Int>("userEventMxBlock")
    public static let eventId = Expression<Int>("userEventId")
    public static let eventCount = Expression<Int>("userEventCount")
    
    public static func createUserEventTable(){
        guard let database = DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return
        }
        do {
            //ifNotExists: true Will NOT create a table if it already exists
            try database.run(userEventTable.create(ifNotExists: true) { userEventTable in
                userEventTable.column(eventMxRoute)
                userEventTable.column(eventMxBlock)
                userEventTable.column(eventId)
                userEventTable.column(eventCount)
            })
             
        }catch {
            print("createUserEventTable already exists: \(error)")
        }
            
    }
    
    public static func insertUserEventsArray(_ contactValues: [UserEventModel]) -> Bool? {
        guard let database = DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return nil
        }

        do {
            try database.run(userEventTable.delete())
            for contactV in try contactValues {
                insertUserEvents(contactV)
            }

        } catch let error {
            print("Updating User Row failed: \(error)")
            return false
        }
        return true
    }
    
    public static func insertUserEvents(_ contactValues: UserEventModel) -> Bool? {
        guard let database =
                DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            try database.run(userEventTable.insert(
                eventMxRoute <- contactValues.UserEventMxRoute,
                eventMxBlock <- contactValues.UserEventMxBlock,
                eventId <- contactValues.UserEventId.rawValue,
                eventCount <- contactValues.UserEventCount))
            
            return true
        }catch let error {
            print("Inserting User Row failed: \(error)")
            return false
        }
    }
    
    public static func getUserEventModelArray() -> [UserEventModel]? {
        guard let database = DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return nil
        }
        
        var userEventArray : [UserEventModel] = []
        
        do {
            
            for point in try database.prepare(userEventTable) {
                let UserEventMxRoute = point[eventMxRoute]
                let UserEventMxBlock = point[eventMxBlock]
                let UserEventId = UserEventId(rawValue: point[eventId])
                let UserEventCount = point[eventCount]
                
                userEventArray.append(UserEventModel(UserEventMxRoute: UserEventMxRoute, UserEventMxBlock: UserEventMxBlock, UserEventId: UserEventId, UserEventCount: UserEventCount))
                

            }
        }catch{
            return nil
        }
        return userEventArray
        
    }
    
    public static func updateUserEventsCount(uEventId: UserEventId) -> Bool? {
        guard let database = DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return nil
        }
        
        let point = userEventTable.filter(eventId == uEventId.rawValue)
        
        do {
            if try database.run(point.update(eventCount <- eventCount + 1)) > 0 {
                print("Updated Point Status1")
                return true
            } else{
                print("Could Not updated Point Status")
                return false
            }
            
        } catch let error {
            print("Updating failed \(error)")
            return false
        }
    }
    
    public static func deleteUserEventTable() -> Bool? {
        guard let database =
                DatabaseServiceLogEvent.getDatabaseLogEvent() else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            try database.run(userEventTable.delete())
            
            return true
        }catch let error {
            print("delete Table: \(error)")
            return false
        }
    }
}
