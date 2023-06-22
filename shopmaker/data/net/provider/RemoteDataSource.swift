//
//  RemoteDataSource.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/20.
//

import Foundation
import RxSwift
import Moya

protocol RemoteDataSource {
    func accounts(userId: String) -> Observable<User.Response>
}

class RemoteDataSourceImpl: RemoteDataSource {
    let provider = MoyaProvider<RemoteAPI>(plugins: [LoggedPlugin()])
    let disposeBag = DisposeBag()
    func accounts(userId: String) -> Observable<User.Response> {
        return self.provider.rx.request(.users(userId: userId))
            .asObservable()
            .mapObject(User.Response.self)
    }
}
