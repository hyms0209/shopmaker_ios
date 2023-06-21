//
//  UserInfoUseCase.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/20.
//


import Foundation
import RxSwift

class UserInfoUseCase {
    var userRepository: UserRepository
    
    init( userRepository: UserRepository ) {
        self.userRepository = userRepository
    }
    
    func users(userId: String) -> Observable<UsersEntity> {
        return self.userRepository.users(userId: userId)
    }
}
