//
//  LocationManagerClientLive.swift
//  locationTest
//
//  Created by Selina on 2023/04/04.
//

import CoreLocation

import Dependencies
import XCTestDynamicOverlay

extension LocationManagerClient: DependencyKey {
    private static let locationManagerDelegate = LocationManagerDelegate(locationManager: CLLocationManager())
    private static let locationManager = CLLocationManager()
    
    public static let liveValue = Self(
        requestAuthorization: {
            switch locationManager.authorizationStatus {
            case .notDetermined: // 처음에 무조건 요청.
                locationManagerDelegate.locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                locationManagerDelegate.showAuthorizationAlert()
                return
            default:
                return
            }
        },
        checkAvailability: {
            if !CLLocationManager.headingAvailable() { return false }
            return true
        },
        authorizationStatus: {
            print("status", locationManagerDelegate.locationManager.authorizationStatus.rawValue)
            return locationManagerDelegate.locationManager.authorizationStatus
        }
    )
}

private final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        
        super.init()
        
        self.locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("👀 location", locations)
    }
    
    func showAuthorizationAlert() {
        // TODO: 설정 가서 권한 바꾸라고 해야함
    }
}
