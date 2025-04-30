//
//  FirebaseAnalyticsManager.swift
//  LogEventSpmKit
//
//  Created by Mustafa Alper Aydin on 30.04.2025.
//

import Foundation
import FirebaseAnalytics
import SwiftUI

public class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    public func logEvent(_ eventType: AnalyticsEventType, parameters: [String: Any]? = nil) {
        Analytics.logEvent(eventType.eventName, parameters: parameters)
    }
    
    public func logScreenView(screenName: String, screenClass: String) {
        let parameters: [String: Any] = [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: AnalyticsParameterScreenName
        ]
        logEvent(.screenView, parameters: parameters)
    }
    
    public func logScreenEvent(screenName: String) {
        let parameters: [String: Any] = [
            AnalyticsParameterScreenName: screenName
        ]
        logEvent(.screenView, parameters: parameters)
    }
    
    public func logButtonClick(buttonName: ButtonnameEnums, screenName: ScreenNameEnums, items: String = "", firebaseAnalyticsUserId: CLong) {
        
        
        let parameters: [String: Any] = [
            AnalyticsParameterItemName: buttonName.rawValue,
            AnalyticsParameterOrigin: screenName.rawValue,
            AnalyticsParameterItemID: "\(firebaseAnalyticsUserId)",
            AnalyticsParameterItems: items
        ]
        //1234567890
        logEvent(.buttonClick, parameters: parameters)
    }
    
    public func logErrorEvent(_ logHistoryId: LogHistoryId, logHistoryType: LogHistoryType, desc: String = "", degress: LogHistoryDegress, source: LogHistorySource = .mbl) {
        
        let parameters: [String: Any] = [
            AnalyticsParameterContent: "logHistoryId:\(logHistoryId.rawValue), logHistoryType:\(logHistoryType), desc:\(desc), degress:\(degress), source:\(source)"
        ]
        logEvent(.error, parameters: parameters)
    }
    
    public func logNavigation(from: String, to: String, type: String) {
        let parameters: [String: Any] = [
            "from_screen": from,
            "to_screen": to,
            "navigation_type": type
        ]
        logEvent(.navigation, parameters: parameters)
    }
}

public enum AnalyticsEventType {
    case buttonClick
    case screenView
    case formSubmit
    case navigation
    case search
    case userAction
    case tabChange
    case alert
    case error
    case custom(String)
    
    var eventName: String {
        switch self {
        case .buttonClick: return "button_click"
        case .screenView: return AnalyticsEventScreenView
        case .formSubmit: return "form_submit"
        case .navigation: return "navigation"
        case .search: return "search"
        case .userAction: return "user_action"
        case .tabChange: return "tab_change"
        case .alert: return "alert"
        case .error: return "log_error"
        case .custom(let name): return name
        }
    }
}

extension View {
    
    public func trackScreenView(screenName: ScreenNameEnums) -> some View {
        self.onAppear {
            AnalyticsManager.shared.logScreenEvent(
                screenName: screenName.rawValue
            )
        }
    }
    
    public func trackNavigation(from: String, to: String) -> some View {
        self.simultaneousGesture(TapGesture().onEnded {
            AnalyticsManager.shared.logNavigation(
                from: from,
                to: to,
                type: "push"
            )
        })
    }
}

/*
extension ScreenNameEnums {
    static let customProjectScrrenName = ScreenNameEnums(rawValue: "customProjectScrrenName")
}
*/

public struct ScreenNameEnums: RawRepresentable, Codable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // Statik olarak tanımlanmış örnekler
    public static let login_screen = ScreenNameEnums(rawValue: "login_screen")
    public static let register_screen = ScreenNameEnums(rawValue: "register_screen")


}

/*
extension ButtonnameEnums {
    static let customProjectButton = ScreenNameEnums(rawValue: "customProjectButton")
}
*/

public struct ButtonnameEnums: RawRepresentable, Codable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // Statik olarak tanımlanmış örnekler
    public static let login_button = ButtonnameEnums(rawValue: "login_button")
    public static let register_button = ButtonnameEnums(rawValue: "register_button")


}
