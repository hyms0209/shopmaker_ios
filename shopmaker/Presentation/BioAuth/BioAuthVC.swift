//
//  BioAuthVC.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/05/19.
//

import UIKit
import RxSwift
import RxCocoa
import LocalAuthentication


enum BioAuth {
    case success
    case fail
    case notSupport
}

class BioAuthVC: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestBioAuth()
    }
    
}

extension BioAuthVC {
    func requestBioAuth() {
        self.authenticateWithBiometrics()
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] authType in
                switch authType {
                case .success:
                    print("Build Success")
                    
                case .fail:
                    print("Build fail")
                    
                case .notSupport:
                    print("Build notSupport")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func authenticateWithBiometrics() -> Observable<BioAuth> {
        return Observable.create { observer in
            let context = LAContext()
            var error: NSError?

            // 바이오 인증 가능 여부 확인
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                let reason = "바이오 인증을 사용하여 로그인합니다."

                // 바이오 인증 실행
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason) {[weak self] success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            // 인증 성공
                            observer.onNext(.success)
                            observer.onCompleted()
                        } else {
                            // 인증 실패 또는 취소
                            observer.onNext(.fail)
                            observer.onCompleted()
                        }
                    }
                }
            } else {
                observer.onNext(.notSupport)
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }
}
