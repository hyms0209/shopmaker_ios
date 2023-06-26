//
//  DirectionUseCase.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/21.
//

import Foundation
import RxSwift
import CoreLocation

class DirectionUseCase {
    var locationRepository: LocationRepository
    
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
    
    func direction(direction: DirectionMap, moveLocation:LocationInfo)-> Observable<DirectionEntity> {
        return self.locationRepository.getCurrentLocation()
            .asObservable()
            .map{
                DirectionEntity(start: $0, end: moveLocation, direction: direction)
            }
    }
}

