//
//  FileDownloadUseCase.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/15.
//

import Foundation
import RxSwift

class FileDownloadUseCase {
    var downloadRepository: FileDownloadRepository
    
    init( downloadRepository: FileDownloadRepository ) {
        self.downloadRepository = downloadRepository
    }
    
    func downloadFile(fileUrl: URL) -> Observable<FileDownloadEntity> {
        return downloadRepository.downloadFile(fileUrl: fileUrl)
    }
}
