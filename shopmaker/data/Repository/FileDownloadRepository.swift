//
//  FileDownloadRepository.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/15.
//

import Foundation
import RxSwift

protocol FileDownloadRepository {
    
    func downloadFile(fileUrl: URL) -> Observable<FileDownloadEntity>
}

class FileDownloadRepositoryImpl: FileDownloadRepository {
    var downloadDataSource: FileDownloadDataSource
    
    var disposeBag = DisposeBag()
    
    init(downloadDataSource: FileDownloadDataSource) {
        self.downloadDataSource = downloadDataSource
    }
    
    func downloadFile(fileUrl: URL) -> Observable<FileDownloadEntity> {
        return Observable<FileDownloadEntity>.create{ observer in
            self.downloadDataSource.downloadFile(url: fileUrl )
                .subscribe(onNext: { data in
                    let entity = FileDownloadEntity(filePath: data, fileName: "")
                    observer.onNext(entity)
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
