//
//  UsersEntity.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/20.
//

import Foundation

struct UsersEntity {
    var users:[UserInfo]
    
    init(dto: User.Response) {
        self.users = dto.map{
            .init(userId: String($0.userId ?? 0),
                  id: String($0.id ?? 0),
                  title: $0.title ?? "",
                  body: $0.body ?? "")
        }
    }
}


struct UserInfo {
    var userId: String
    var id: String
    var title: String
    var body: String
    
    init(userId: String, id: String, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}
