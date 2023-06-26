//
//  DirectionEntity.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/21.
//

import Foundation


enum DirectionMap: String {
    case kakao
    case naver
    case apple
    case googlemaps
    
    func getMoveScheme(
        startLocation: LocationInfo,
        endLocation: LocationInfo
    ) -> String {
        return getScheme() + "://" + 
                getDomain() +
                getParameter(
                    startLocation: startLocation,
                    endLocation: endLocation
                )
    }
    
    private func getScheme() -> String {
        switch self {
        case .kakao: return "kakaomap"
        case .naver: return "nmap"
        case .apple: return "http"
        case .googlemaps : return "comgooglemaps"
        }
    }
    
    private func getDomain() -> String {
        switch self {
        case .kakao: return "route"
        case .naver: return "route/car"
        case .apple: return "maps.apple.com/"
        case .googlemaps: return ""
        }
    }
    
    private func getParameter(startLocation: LocationInfo, endLocation: LocationInfo) -> String {
        switch self {
        case .kakao:
            return getKakaoParameter(
                startLocation: startLocation,
                endLocation: endLocation
            )
            
        case .naver:
            return getNaverMapParameter(
                startLocation: startLocation,
                endLocation: endLocation
            )
            
        case .apple:
            return getAppleParameter(
                startLocation: startLocation,
                endLocation: endLocation
            )
            
        case .googlemaps:
            return getGoogleMapsParameter(
                startLocation: startLocation,
                endLocation: endLocation
            )
        }
    }
    
    private func getKakaoParameter(
        startLocation: LocationInfo,
        endLocation: LocationInfo
    ) -> String {
        return "?sp=\(startLocation.latitude),\(startLocation.longitude)"
            .appending("&ep=")
            .appending("\(endLocation.latitude),\(endLocation.longitude)")
            .appending("&by=CAR")
    }
    
    private func getNaverMapParameter(
        startLocation: LocationInfo,
        endLocation: LocationInfo
    ) -> String {
        return "?slat=\(startLocation.latitude)"
            .appending("&slng=\(startLocation.longitude)")
            .appending("&dlat=\(endLocation.latitude)")
            .appending("&dlng=\(endLocation.longitude)")
            .appending("&appname=com.ios.lotteautolease")
    }
    
    private func getAppleParameter(
        startLocation: LocationInfo,
        endLocation: LocationInfo
    ) -> String {
        return "?saddr=\(startLocation.latitude),\(startLocation.longitude)"
            .appending("&daddr=")
            .appending("\(endLocation.latitude),\(endLocation.longitude)")
            .appending("&dirflg=d")
    }
    
    private func getGoogleMapsParameter(
        startLocation: LocationInfo,
        endLocation: LocationInfo
    ) -> String {
        return "?saddr=\(startLocation.latitude),\(startLocation.longitude)"
            .appending("&daddr=")
            .appending("\(endLocation.latitude),\(endLocation.longitude)")
            .appending("&directionsmode=driving")
    }
}

struct DirectionEntity {
    var startLocation: LocationInfo
    var endLocation: LocationInfo
    var direction: DirectionMap
    init(
        start: LocationInfo,
        end: LocationInfo,
        direction: DirectionMap
    ) {
        self.startLocation = start
        self.endLocation = end
        self.direction = direction
    }
    
    func getMoveScheme() -> String {
        return direction.getMoveScheme(
            startLocation: self.startLocation,
            endLocation: self.endLocation
        )
    }
}

