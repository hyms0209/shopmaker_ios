//
//  UserRepository.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/20.
//

import Foundation
import RxSwift

protocol UserRepository {
    func users(userId: String) -> Observable<UsersEntity>
}

class UserRepositoryImpl: UserRepository {
    var remoteDataSource: RemoteDataSource
    
    var disposeBag = DisposeBag()
    
    init(remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func users(userId: String) -> Observable<UsersEntity> {
        self.remoteDataSource.accounts(userId: userId)
            .map {
                UsersEntity(dto: $0)
            }
    }
}
