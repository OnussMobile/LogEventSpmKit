//
//  File.swift
//  LogEventSpmKit
//
//  Created by Mustafa Alper Aydin on 29.04.2025.
//

import Foundation

//updateSqlLogHistory(.sqlinit, logHistoryType: .sql, desc: "\(error)", degress: .error)

func updateSqlLogHistory(_ logHistoryId: LogHistoryId, logHistoryType: LogHistoryType, desc: String = "", degress: LogHistoryDegress, source: LogHistorySource = .mbl, comment: String = "") {
    CrashlyticsLogger.log(from: LogHistoryModel(LogHistoryPageType: pageType, LogHistoryMxRoute: SQLiteCommands.getUser(type: 123)?.CompanyUserId ?? -1, LogHistoryMxBlock: SQLiteCommands.getUser(type: 125)?.CompanyUserId ?? -1, LogHistoryType: logHistoryType, LogHistoryId: logHistoryId, LogHistoryDesc: desc, LogHistoryCount: 1, LogHistoryDegress: degress, LogHistorySource: source, LogHistoryComment: comment))
    var array = LogEventSqlManager.getLogHistoryModelArray()
    if array != [] {
        if array!.contains(where: { $0.LogHistoryId == logHistoryId }) {
            LogEventSqlManager.updateLogHistoryCount(logHistoryId: logHistoryId)
        } else {
            var log = LogHistoryModel(LogHistoryPageType: pageType, LogHistoryMxRoute: SQLiteCommands.getUser(type: 123)?.CompanyUserId ?? -1, LogHistoryMxBlock: SQLiteCommands.getUser(type: 125)?.CompanyUserId ?? -1, LogHistoryType: logHistoryType, LogHistoryId: logHistoryId, LogHistoryDesc: desc, LogHistoryCount: 1, LogHistoryDegress: degress, LogHistorySource: source, LogHistoryComment: comment)
            LogEventSqlManager.insertLogHistory(log)
            setMobileLog(log: log)
        }
    } else {
        var log = LogHistoryModel(LogHistoryPageType: pageType, LogHistoryMxRoute: SQLiteCommands.getUser(type: 123)?.CompanyUserId ?? -1, LogHistoryMxBlock: SQLiteCommands.getUser(type: 125)?.CompanyUserId ?? -1, LogHistoryType: logHistoryType, LogHistoryId: logHistoryId, LogHistoryDesc: desc, LogHistoryCount: 1, LogHistoryDegress: degress, LogHistorySource: source, LogHistoryComment: comment)
        LogEventSqlManager.insertLogHistory(log)
        setMobileLog(log: log)
        //apiye git
    }
}

/*func setMobileLog(isEndday: Bool = false, log: LogHistoryModel) {
    
    let mobileId: String = preferences.string(forKey: "token") ?? ""
    
    var excStr = "PageType: \(log.LogHistoryPageType), Tip: \(log.LogHistoryType), Önem: \(log.LogHistoryDegress), Count: \(log.LogHistoryCount), IsTotal: \(isEndday), Commment: \(log.LogHistoryComment), Source: \(log.LogHistorySource), StackTrace: \(log.LogHistoryDesc)"
    
    
    NetworkManager().setMobileLog(methodName: log.LogHistoryId, logStr: excStr, importance: log.LogHistoryDegress, errorType: "\(log.LogHistoryType)", mobileId: mobileId, completion: { result in
        switch result {
        case .success(let loginUserResponse):
            
            guard let jsonString = try? JSONDecoder().decode(String.self, from: loginUserResponse) else {
                print("(Result Boş)")
                return
            }
            let jsonData = jsonString.data(using: .utf8)!
            print("getUserBlockInfo-- \(jsonString)")
            if(jsonString.contains("ErrorCode")){
                guard let errorClass = try? JSONDecoder().decode([ErrorClass].self, from: jsonData) else {
                    print("(ErrorClass Boş)")
                    return
                }
                
            }else{
                
                guard let result = try? JSONDecoder().decode(Int.self, from: jsonData) else {
                    print("(LoginResult Boş)")
                    return
                }
                
            }
             
        case .failure(let error):
            print("failure")
        }
        
    })

} */

//SQLiteDatabase createTable içine
//LogEventSpmKit.LogEventSqlManager..createTable()

//Appdelegate içine
/*class SQLiteDatabaseProvider: DatabaseProviderLogEvent {
 var databaseLogEvent: Connection? {
     return SQLiteDatabase.sharedInstance.database
 }
}*/
//DatabaseServiceLogEvevt.provider = SQLiteDatabaseProvider()

public struct LogHistoryModel : Codable, Hashable{
    
    public var LogHistoryPageType: String = ""
    public var LogHistoryMxRoute: Int = -1
    public var LogHistoryMxBlock: Int = -1
    public var LogHistoryType: LogHistoryType = .historyTypeNull
    public var LogHistoryId: LogHistoryId = .hata1
    public var LogHistoryDesc: String = ""
    public var LogHistoryCount: Int = 0
    public var LogHistoryDegress: LogHistoryDegress = .onemsiz
    public var LogHistorySource: LogHistorySource = .mbl
    public var LogHistoryComment: String = ""
    
    public init(){ }
    
    public init(LogHistoryPageType: String, LogHistoryMxRoute: Int, LogHistoryMxBlock: Int, LogHistoryType: LogHistoryType, LogHistoryId: LogHistoryId, LogHistoryDesc: String, LogHistoryCount: Int, LogHistoryDegress: LogHistoryDegress, LogHistorySource: LogHistorySource, LogHistoryComment: String){
        
        self.LogHistoryPageType = LogHistoryPageType
        self.LogHistoryMxRoute = LogHistoryMxRoute
        self.LogHistoryMxBlock = LogHistoryMxBlock
        self.LogHistoryType = LogHistoryType
        self.LogHistoryId = LogHistoryId
        self.LogHistoryDesc = LogHistoryDesc
        self.LogHistoryCount = LogHistoryCount
        self.LogHistoryDegress = LogHistoryDegress
        self.LogHistorySource = LogHistorySource
        self.LogHistoryComment = LogHistoryComment
    
    }
}

/*
extension LogHistoryId {
    static let customProjectLog = LogHistoryId(rawValue: "customProjectLog")
}
*/

public struct LogHistoryId: RawRepresentable, Codable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // Statik olarak tanımlanmış örnekler
    public static let hata1 = LogHistoryId(rawValue: "hata1")
    public static let sqlinit = LogHistoryId(rawValue: "sqlinit")
    public static let sqlupdate = LogHistoryId(rawValue: "sqlupdate")
    public static let createSqlTable = LogHistoryId(rawValue: "createSqlTable")
    public static let insertSqlTable = LogHistoryId(rawValue: "insertSqlTable")
    public static let updateSqlTable = LogHistoryId(rawValue: "updateSqlTable")
    public static let deleteSqlTable = LogHistoryId(rawValue: "deleteSqlTable")
    public static let networkRequest = LogHistoryId(rawValue: "networkRequest")
    public static let resultBos = LogHistoryId(rawValue: "resultBos")
    public static let html2String = LogHistoryId(rawValue: "html2String")
    public static let hereInitialize = LogHistoryId(rawValue: "hereInitialize")
    public static let hereInitializeLogin = LogHistoryId(rawValue: "hereInitializeLogin")
    public static let getRemoteConfig = LogHistoryId(rawValue: "getRemoteConfig")
    public static let getRemoteConfigLogin = LogHistoryId(rawValue: "getRemoteConfigLogin")
    public static let fetchLocations = LogHistoryId(rawValue: "fetchLocations")
    public static let searchEngine = LogHistoryId(rawValue: "searchEngine")
    public static let playSound = LogHistoryId(rawValue: "playSound")
    public static let routingEngine = LogHistoryId(rawValue: "routingEngine")


}


public enum LogHistoryType: Int, Codable {
    case historyTypeNull = 0
    case global = 1
    case network = 2
    case sql = 3
    case user = 4
    case performance = 5
    case security = 6
    case format = 7
    case config = 8
    case fremawork = 9
    case event = 10
    case equip = 11
}

public enum LogHistoryDegress : Int, Codable {
    case onemsiz = 0
    case fatal = 1
    case error = 2
    case warning = 3
    case info = 4
    case debug = 5
}

public enum LogHistorySource : Int, Codable {
    case mbl = 1
    case db = 2
}
