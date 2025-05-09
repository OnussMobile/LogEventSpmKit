//
//  Log_EvetManager.swift
//  LogEventSpmKit
//
//  Created by Mustafa Alper Aydin on 9.05.2025.
//

public class LogEventManager {
    
    static let shared = LogEventManager()
    private init() {}
    
    public func updateSqlLogHistory(_ logHistoryId: LogHistoryId, logHistoryType: LogHistoryType, desc: String = "", degress: LogHistoryDegress, source: LogHistorySource = .mbl, comment: String = "", pageType: String, mxRoute: Int, mxBlock: Int) -> LogHistoryModel? {
        
        var array = LogEventSqlManager.getLogHistoryModelArray()
        let log = LogHistoryModel(
                LogHistoryPageType: pageType,
                LogHistoryMxRoute: mxRoute,
                LogHistoryMxBlock: mxBlock,
                LogHistoryType: logHistoryType,
                LogHistoryId: logHistoryId,
                LogHistoryDesc: desc,
                LogHistoryCount: 1,
                LogHistoryDegress: degress,
                LogHistorySource: source,
                LogHistoryComment: comment
            )

            CrashlyticsLogger.log(from: log)

            guard let array = LogEventSqlManager.getLogHistoryModelArray(), !array.isEmpty else {
                LogEventSqlManager.insertLogHistory(log)
                return log
            }

            if array.contains(where: { $0.LogHistoryId == logHistoryId }) {
                LogEventSqlManager.updateLogHistoryCount(logHistoryId: logHistoryId)
                return nil
            } else {
                LogEventSqlManager.insertLogHistory(log)
                return log
            }
    }
    
    public func updateSqlUserEvent(_ userEventId: UserEventId, buttonName: ButtonnameEnums, screenName: ScreenNameEnums, items: String = "", firebaseAnalyticsUserId: CLong,  mxRoute: Int, mxBlock: Int) {
        var array = LogEventSqlManager.getUserEventModelArray()
        if buttonName != .none_button {
            AnalyticsFunction.shared.logButtonClickAnalytic(buttonName: buttonName, screenName: screenName, items: items, firebaseAnalyticsUserId: firebaseAnalyticsUserId)
        }
        if screenName != .none_screen {
            AnalyticsFunction.shared.logScreenEventAnalytic(screenName: screenName.rawValue)
        }
        if array != [] {
            if array!.contains(where: { $0.UserEventId == userEventId }) {
                LogEventSqlManager.updateUserEventsCount(uEventId: userEventId)
            } else {
                LogEventSqlManager.insertUserEvents(UserEventModel(UserEventMxRoute: mxRoute, UserEventMxBlock: mxBlock, UserEventId: userEventId, UserEventCount: 1))
            }
        } else {
            LogEventSqlManager.insertUserEvents(UserEventModel(UserEventMxRoute: mxRoute, UserEventMxBlock: mxBlock, UserEventId: userEventId, UserEventCount: 1))
        }
    }
}

//projede ana fonksiyon olarak bu çağırılacak, sonrasında
//updateLogHistory(.createSqlTable, logHistoryType: .config, degress: .debug, pageType: "pagetype", mxRoute: 1, mxBlock: 1)
func updateLogHistory(_ logHistoryId: LogHistoryId, logHistoryType: LogHistoryType, desc: String = "", degress: LogHistoryDegress, source: LogHistorySource = .mbl, comment: String = "", pageType: String, mxRoute: Int, mxBlock: Int) {
    if let log = LogEventManager.shared.updateSqlLogHistory(.createSqlTable, logHistoryType: .config, degress: .debug, pageType: "", mxRoute: 1, mxBlock: 1) {
        //setMobileLog(log: log) apiye git
    }
}

//projede ana fonksiyon olarak bu çağırılacak, sonrasında
//updateUserEvent(.eventNull, buttonName: .login_button, screenName: .login_screen, firebaseAnalyticsUserId: 1, mxRoute: 1, mxBlock: 1)
func updateUserEvent(_ userEventId: UserEventId, buttonName: ButtonnameEnums, screenName: ScreenNameEnums, items: String = "", firebaseAnalyticsUserId: CLong,  mxRoute: Int, mxBlock: Int) {
    LogEventManager.shared.updateSqlUserEvent(userEventId, buttonName: buttonName, screenName: screenName, items: items, firebaseAnalyticsUserId: firebaseAnalyticsUserId, mxRoute: mxRoute, mxBlock: mxBlock)
    
}
