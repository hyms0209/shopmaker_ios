//
//  LocationManager.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/21.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var authorizationStatusRelay = PublishRelay<CLAuthorizationStatus>()
    private var locationSubject = PublishSubject<CLLocationCoordinate2D>()
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    func requestLocationPermission() -> Observable<CLAuthorizationStatus> {
        let observer = authorizationStatusRelay.asObservable()
        let authorizationStatus = self.getInitialAuthorizationStatus()
        if authorizationStatus == .notDetermined {
            self.locationManager?.requestWhenInUseAuthorization()
            return observer.asObservable()
        } else {
            return observer.asObservable().startWith(authorizationStatus)
        }
    }
    
    private func getInitialAuthorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager!.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    func getCurrentLocation() -> Observable<CLLocationCoordinate2D> {
        return requestLocationPermission()
            .flatMap { [weak self] authorizationStatus -> Observable<CLLocationCoordinate2D> in
                guard let self = self else { return Observable.empty() }
                
                if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                    self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                    self.locationManager?.startUpdatingLocation()
                    
                    return self.locationSubject.asObservable()
                        .take(1)
                } else {
                    throw NSError(domain: "LocationPermission", code: 0, userInfo: nil)
                }
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationSubject.onNext(location.coordinate)
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = getInitialAuthorizationStatus()
        authorizationStatusRelay.accept(authorizationStatus)
    }
}
