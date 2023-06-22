//
//  LocationInfo.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/21.
//

import Foundation
import CoreLocation

struct LocationInfo {
    var latitude: Double
    var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
