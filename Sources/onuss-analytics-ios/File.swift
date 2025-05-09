//
//  File.swift
//  LogEventSpmKit
//
//  Created by Mustafa Alper Aydin on 8.05.2025.
//

import FirebaseCrashlytics


public struct CrashlyticsLogger {

    public static func log(from model: LogHistoryModel, errorDescription: String = "LogHistory Error", errorCode: Int = 999) {
        let userInfo: [String: Any] = [
            "LogHistoryPageType": model.LogHistoryPageType,
            "LogHistoryMxRoute": model.LogHistoryMxRoute,
            "LogHistoryMxBlock": model.LogHistoryMxBlock,
            "LogHistoryType": model.LogHistoryType.rawValue,
            "LogHistoryId": model.LogHistoryId.rawValue,
            "LogHistoryDesc": model.LogHistoryDesc,
            "LogHistoryCount": model.LogHistoryCount,
            "LogHistoryDegress": model.LogHistoryDegress.rawValue,
            "LogHistorySource": model.LogHistorySource.rawValue,
            "LogHistoryComment": model.LogHistoryComment,
            NSLocalizedDescriptionKey: errorDescription
        ]

        let error = NSError(domain: "loghistory", code: errorCode, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
}
