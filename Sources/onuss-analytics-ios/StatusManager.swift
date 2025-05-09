//
//  File 2.swift
//  onuss-analytics-ios
//
//  Created by Mustafa Alper Aydin on 9.05.2025.
//

import Foundation
import CoreLocation
import Network
import UIKit

public class StatusManager: NSObject, CLLocationManagerDelegate {
    
    public static let shared = StatusManager()

    private let locationManager = CLLocationManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private(set) public var isInternetConnected: Bool = false
    private(set) public var isLocationAuthorized: Bool = false
    private(set) public var isLocationAlwaysAuthorized: Bool = false
    private(set) public var isLocationEnabled: Bool = false
    private(set) public var locationProvider: String = "BILINMIYOR"

    private override init() {
        super.init()
        locationManager.delegate = self
        startMonitoring()
    }

    // MARK: - Başlat
    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isInternetConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)

        checkLocationAuthorization()
    }

    // MARK: - Konum Yetkisi
    public func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        isLocationEnabled = CLLocationManager.locationServicesEnabled()
        
        switch status {
        case .authorizedAlways:
            isLocationAuthorized = true
            isLocationAlwaysAuthorized = true
        case .authorizedWhenInUse:
            isLocationAuthorized = true
            isLocationAlwaysAuthorized = false
        default:
            isLocationAuthorized = false
            isLocationAlwaysAuthorized = false
        }
    }

    // MARK: - Konum Sağlayıcı (GPS, BAZ)
    public func updateLocationProvider(location: CLLocation?) {
        guard let accuracy = location?.horizontalAccuracy else {
            locationProvider = "BILINMIYOR"
            return
        }
        if accuracy <= 0 {
            locationProvider = "GEÇERSİZ"
        } else if accuracy < 10 {
            locationProvider = "GPS"
        } else {
            locationProvider = "BAZ"
        }
    }

    // MARK: - Uçak Modu (Dolaylı)
    public var isAirplaneModeOn: Bool {
        return !isInternetConnected && !isLocationEnabled
    }

    // MARK: - Ekran açık mı?
    public var isScreenOn: Bool {
        return UIScreen.main.brightness > 0
    }

    // MARK: - Lokasyon alınamıyor durumu (örnek kontrol)
    public var isLocationUnavailable: Bool {
        return !isLocationAuthorized || !isLocationEnabled
    }

    // MARK: - Durum Raporu
    public func generateStatusReport() -> String {
        return """
        LokasyonYetkisi: \(isLocationAuthorized ? "AÇIK" : "KAPALI"),
        LokasyonServisi: \(isLocationEnabled ? "AÇIK" : "KAPALI"),
        LokasyonModu: \(locationProvider),
        Internet: \(isInternetConnected ? "VAR" : "YOK"),
        UçakModu: \(isAirplaneModeOn ? "AÇIK" : "KAPALI"),
        Ekran: \(isScreenOn ? "AÇIK" : "KAPALI")
        """
    }

    // MARK: - CLLocation Delegate
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

/*let report = StatusManager.shared.generateStatusReport()
print("Durum Raporu:\n\(report)")*/

/*
 // 📍 Lokasyon izni açık mı?
 let isLocationAuthorized = StatusManager.shared.isLocationAuthorized

 // 📍 Lokasyon izni "Always" mi?
 let isAlways = StatusManager.shared.isLocationAlwaysAuthorized

 // 📡 Lokasyon servisi açık mı?
 let isLocationEnabled = StatusManager.shared.isLocationEnabled

 // 🌐 İnternet var mı?
 let isInternetAvailable = StatusManager.shared.isInternetConnected

 // 🛫 Uçak modu açık mı (dolaylı kontrol)?
 let isAirplaneModeOn = StatusManager.shared.isAirplaneModeOn

 // 💡 Ekran açık mı?
 let isScreenOn = StatusManager.shared.isScreenOn

 // 🛰 Lokasyon sağlayıcı bilgisi (GPS, BAZ, GEÇERSİZ)
 let locationProviderType = StatusManager.shared.locationProvider

 // ❌ Lokasyon alınamıyor mu?
 let isLocationUnavailable = StatusManager.shared.isLocationUnavailable
 */
