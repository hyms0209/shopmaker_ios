//
//  LocationRepository.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/21.
//

import Foundation
import RxSwift

protocol LocationRepository {
    func getCurrentLocation() -> Observable<LocationInfo>
}

class LocationRepositoryImpl: LocationRepository {
    
    var locationManager: LocationManager
    init() {
        self.locationManager = LocationManager()
    }
    
    func getCurrentLocation() -> Observable<LocationInfo> {
        return locationManager.getCurrentLocation()
            .map{
                LocationInfo(latitude: $0.latitude, longitude: $0.longitude)
            }
    }
}
