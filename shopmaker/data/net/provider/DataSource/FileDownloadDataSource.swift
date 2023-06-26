//
//  FileDownloadDataSource.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/15.
//

import Foundation
import RxSwift
import Moya

protocol FileDownloadDataSource {
    func downloadFile(url: URL) -> Observable<String>
}

class FileDownloadDataSourceImpl: FileDownloadDataSource {

    
    // 사용 예시
    let provider = MoyaProvider<FileDownloadAPI>()
    let disposeBag = DisposeBag()

    func downloadFile(url: URL) -> Observable<String> {
        return Observable.create{[weak self] observer in
            
            if let self = self {
                self.provider.rx.request(.downloadFile(url: url))
                    .asObservable()
                    .subscribe(onNext:{[weak self] response in
                           let statusCode = response.statusCode
                           if 200...299 ~= statusCode {
                               do {
                                   let fileName = url.lastPathComponent
                                   let destinationURL = FileManager.default.urls(
                                    for: .documentDirectory,
                                    in: .userDomainMask)[0]
                                       .appendingPathComponent(fileName)
                                   try response.data.write(to: destinationURL)
                                   return observer.onNext(destinationURL.absoluteString)
                               } catch {
                                   return observer.onError(error)
                               }
                           } else {
                               let error = NSError(domain: "NetworkError", code: statusCode, userInfo: nil)
                               return observer.onError(error)
                           }
                    })
                    .disposed(by: self.disposeBag)
            } else {
                observer.onNext("")
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

