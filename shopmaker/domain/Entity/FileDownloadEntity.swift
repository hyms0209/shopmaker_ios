//
//  FileDownloadEntity.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/15.
//

import Foundation

struct FileDownloadEntity {
    var filePath: String
    var fileName: String
    
    init(filePath: String?, fileName: String?) {
        self.filePath = filePath ?? ""
        self.fileName = fileName ?? ""
    }
    
    func isEmpty() -> Bool {
        return filePath.isEmpty
    }
    
    func getFileFullPath() -> String {
        return filePath
    }
}
