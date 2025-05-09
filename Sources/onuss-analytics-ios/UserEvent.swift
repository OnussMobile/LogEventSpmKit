//
//  Untitled.swift
//  LogEventSpmKit
//
//  Created by Mustafa Alper Aydin on 30.04.2025.
//

import SwiftUICore


//updateSqlUserEvent(.eventNull)
//updateSqlUserEvent(.eventNull, buttonName: .none_button, screenName: .login_screen, firebaseAnalyticsUserId: 1) butonsuz bir userevent ise none_button - sayfa gönderilmeyecek ise none_screen


func updateSqlUserEvent(_ userEventId: UserEventId, buttonName: ButtonnameEnums, screenName: ScreenNameEnums, items: String = "", firebaseAnalyticsUserId: CLong) {
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
            //LogEventSqlManager.insertUserEvents(UserEventModel(UserEventMxRoute: SQLiteCommands.getUser(type: 123)?.MxRouteId ?? -1, UserEventMxBlock: SQLiteCommands.getUser(type: 123)?.MxBlockId ?? -1, UserEventId: userEventId, UserEventCount: 1))
        }
    } else {
        //LogEventSqlManager.insertUserEvents(UserEventModel(UserEventMxRoute: SQLiteCommands.getUser(type: 123)?.MxRouteId ?? -1, UserEventMxBlock: SQLiteCommands.getUser(type: 125)?.MxBlockId ?? -1, UserEventId: userEventId, UserEventCount: 1))
    }
}


public struct UserEventModel : Codable, Hashable{
    
    public var UserEventMxRoute: Int = -1
    public var UserEventMxBlock: Int = -1
    public var UserEventId: UserEventId = .eventNull
    public var UserEventCount: Int = 0

    public init(){ }
    
    public init(UserEventMxRoute: Int, UserEventMxBlock: Int, UserEventId: UserEventId, UserEventCount: Int){
        
        self.UserEventMxRoute = UserEventMxRoute
        self.UserEventMxBlock = UserEventMxBlock
        self.UserEventId = UserEventId
        self.UserEventCount = UserEventCount
    
    }
}

/*
extension UserEventId {
    static let customProjectEvent = UserEventId(rawValue: -1)
}
*/

public struct UserEventId: RawRepresentable, Codable, Hashable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    // Statik olarak tanımlanmış örnekler
    public static let eventNull = UserEventId(rawValue: 0)
    public static let fOtoSırala = UserEventId(rawValue: 11)
    public static let fMahalleSırala = UserEventId(rawValue: 22)
    public static let fTakas = UserEventId(rawValue: 33)
    public static let fYenile = UserEventId(rawValue: 44)


}

