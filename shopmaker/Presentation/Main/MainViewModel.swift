//
//  MainViewModel.swift
//  shopmaker
//
//  Created by lms on 2022/09/30.
//

import Foundation
import RxSwift
import RxRelay

protocol MainViewModelType {
    var input:MainViewModelInput { get }
    var output:MainViewModelOutput { get }
}

protocol MainViewModelInput{
    func downloadFile(url:URL)
    func bioAuth()
    func direction(direction: DirectionMap, location: LocationInfo) 
}

protocol MainViewModelOutput{
    var openShare: PublishRelay<URL> { get }
    var openBioAuth: PublishRelay<Void> { get }
    var openUrlScheme: PublishRelay<String> { get }
}

class MainViewModel : MainViewModelType  {

    var disposeBag = DisposeBag()
    
    var fileDownloadUsecase: FileDownloadUseCase
    var userInfoUsecase: UserInfoUseCase
    var directionUsecase: DirectionUseCase
    
    var openShareActivity: PublishRelay<URL> = .init()
    var openBioAuthActivity: PublishRelay<Void> = .init()
    var directionReplay: PublishRelay<String> = .init()
    
    init(
        fileDownloadUsecase: FileDownloadUseCase,
        userInfoUsecase: UserInfoUseCase,
        directionUsecase: DirectionUseCase
    ) {
        self.fileDownloadUsecase = fileDownloadUsecase
        self.userInfoUsecase = userInfoUsecase
        self.directionUsecase = directionUsecase
    }
}

extension MainViewModel: MainViewModelInput {
    
    var input: MainViewModelInput{ self }
    
    /**
     * 파일 다운로드 처리
     */
    func downloadFile(url:URL) {
        fileDownloadUsecase.downloadFile(fileUrl: url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] entity in
                print(entity)
                // 파일다운로드 완료 후 파일공유
                let url = URL(fileURLWithPath: entity.getFileFullPath())
                self?.openShareActivity.accept(url)
            })
            .disposed(by: disposeBag)
    }
    
    /**
     * 생체인증 요청처리
     */
    func bioAuth() {
        self.userInfoUsecase.users(userId: "2")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] response in
                guard let self = self else { return }
                response.users.forEach({
                    print($0)
                })
            })
            .disposed(by: disposeBag)
    }
    
    /**
     * 길찾기
     */
    func direction(direction: DirectionMap, location: LocationInfo) {
        self.directionUsecase.direction(
            direction: .googlemaps,
            moveLocation:
                LocationInfo(
                    latitude: 37.5043133,
                    longitude: 127.0632608
                )
        )
        .asObservable()
        .subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            output.openUrlScheme.accept(response.getMoveScheme())
        })
        .disposed(by: disposeBag)
    }
}

extension MainViewModel: MainViewModelOutput {
    var output: MainViewModelOutput{ self }
    
    var openBioAuth: PublishRelay<Void> {
        openBioAuthActivity
    }
    
    var openShare: PublishRelay<URL> {
        openShareActivity
    }
    
    var openUrlScheme: PublishRelay<String> {
        self.directionReplay
    }
}
