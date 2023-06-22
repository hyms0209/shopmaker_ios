//
//  User.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/20.
//

import Foundation

enum User {
    typealias Response = [UserInfo]
    // MARK: - BannerResponse
    struct UserInfo: Codable {
        var userId: Int?
        var id: Int?
        var title: String?
        var body: String?
    }
}
