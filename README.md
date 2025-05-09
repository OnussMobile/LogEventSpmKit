# AppDelegate'de SQLite Veritabanı Entegrasyonu

Bu bölüm, AppDelegate içinde SQLite veritabanı sağlayıcısını ve log event (kayıt olayı) hizmetlerini nasıl kuracağınızı açıklar. SQLite ve LogEvent işlevlerini uygulamanıza entegre etmek için şu adımları takip edin.

### Adım 1: `SQLiteDatabaseProvider` Sınıfını Oluşturun

`AppDelegate.swift` dosyanızda, `DatabaseProviderLogEvent` protokolüne uyan bir sınıf oluşturun. Bu sınıf, SQLite veritabanına bağlantı sağlayacaktır.

```swift
class SQLiteDatabaseProvider: DatabaseProviderLogEvent {

    var databaseLogEvent: Connection? {
        return SQLiteDatabase.sharedInstance.database
    }
}
```

# AppDelegate'de SQLite Veritabanı Entegrasyonu

`AppDelegate.swift` dosyanızda, `SQLiteDatabaseProvider` sınıfını başlatın ve DatabaseServiceLogEvent.provider değerine atayın.

```swift
DatabaseServiceLogEvent.provider = SQLiteDatabaseProvider()
```

# LogEventSqlManager ile Tablo Oluşturun

`SQLiteDatabase` içinde tablo oluşturmak için, LogEventSqlManager’ın createTable() metodunu çağırın. Bu, log event (kayıt olayı) için gerekli olan tabloyu kuracaktır.

```swift
LogEventSpmKit.LogEventSqlManager.createTable()
```

# Log ve Event Yönetimi

Uygulama içinde log ve event yönetimini daha verimli hale getirmek için kullanılan fonksiyonlar ve yapıların detayları aşağıda verilmiştir.

## 1. Yeni Log ID Tanımlama

Aşağıdaki kod ile yeni bir `LogHistoryId` tanımlanabilir:

```swift
extension LogHistoryId {
  static let customProjectLog = LogHistoryId(rawValue: "customProjectLog")
}
```

## 2. Yeni Event ID Tanımlama

Aşağıdaki kod ile yeni bir `UserEventId` tanımlanabilir:

 ```swift 
 extension UserEventId {
  static let customProjectEvent = UserEventId(rawValue: -1)
}
```


## 3. Event İçin Global Fonksiyon

Event verilerini güncellemek için kullanılan fonksiyon:

```swift 
func updateSqlUserEvent(_ userEventId: UserEventId) {
   var array = LogEventSqlManager.getUserEventModelArray()
      if array != [] {
           if array!.contains(where: { $0.UserEventId == userEventId }) {
                LogEventSqlManager.updateUserEventsCount(uEventId: userEventId)
            } else {
                LogEventSqlManager.insertUserEvents(UserEventModel(UserEventMxRoute: -1, UserEventMxBlock: -1, UserEventId: userEventId, UserEventCount: 1))
            }
        } else {
            LogEventSqlManager.insertUserEvents(UserEventModel(UserEventMxRoute: -1, UserEventMxBlock: -1, UserEventId: userEventId, UserEventCount: 1))
        }
    }
```

**Uygulama İçinde Kullanım:**

 ```swift 
 updateSqlUserEvent(.customProjectEvent)
``` 

## 4. Log İçin Global Fonksiyon

Log verilerini güncellemek için kullanılan fonksiyon:

 ```swift 
func updateSqlLogHistory(_ logHistoryId: LogHistoryId, logHistoryType: LogHistoryType, desc: String = "", degress: LogHistoryDegress, source: LogHistorySource = .mbl, comment: String = "") {

        var array = LogEventSqlManager.getLogHistoryModelArray()

        if array != [] {

            if array!.contains(where: { $0.LogHistoryId == logHistoryId }) {

                LogEventSqlManager.updateLogHistoryCount(logHistoryId: logHistoryId)

            } else {

                var log = LogHistoryModel(LogHistoryPageType: "pageType", LogHistoryMxRoute: -1, LogHistoryMxBlock: -1, LogHistoryType: logHistoryType, LogHistoryId: logHistoryId, LogHistoryDesc: desc, LogHistoryCount: 1, LogHistoryDegress: degress, LogHistorySource: source, LogHistoryComment: comment)

                LogEventSqlManager.insertLogHistory(log)

                //setMobileLog(log: log)

                //apiye git

            }

        } else {

            var log = LogHistoryModel(LogHistoryPageType: "pageType", LogHistoryMxRoute: -1, LogHistoryMxBlock: -1, LogHistoryType: logHistoryType, LogHistoryId: logHistoryId, LogHistoryDesc: desc, LogHistoryCount: 1, LogHistoryDegress: degress, LogHistorySource: source, LogHistoryComment: comment)

            LogEventSqlManager.insertLogHistory(log)

            //setMobileLog(log: log)

            //apiye git

        }

    }
```
**Uygulama İçinde Kullanım:**

```swift 
updateSqlLogHistory(.customProjectLog, logHistoryType: .sql, desc: "\("error")", degress: .error)
```
---
