//
//  RemoteAPI.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/20.
//

import Foundation
import RxSwift
import RxSwiftExt
import Alamofire
import Moya

enum RemoteAPI {
    case users(userId: String)
}

extension RemoteAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var path: String {
        switch self {
        case .users:
            return "/posts"
        }
    }

    var method: Moya.Method {
        switch self {
        case .users:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .users(let userId):
            return .requestParameters(parameters: ["userId":userId], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var sampleData: Data {
        return Data()
    }
}
