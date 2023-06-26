//
//  FileDownloadAPI.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/15.
//

import Foundation
import RxSwift
import RxSwiftExt
import Alamofire
import Moya



let destination: DownloadRequest.Destination = { _, _ in
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("file.pdf")
    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
}


enum FileDownloadAPI {
    case downloadFile(url: URL)
}

extension FileDownloadAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://example.com")!
    }

    var path: String {
        switch self {
        case .downloadFile:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .downloadFile:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .downloadFile(let url):
            let fileName = url.lastPathComponent
            let destinationURL = FileManager.default.urls(
             for: .documentDirectory,
             in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
            var downloadDestination: DownloadDestination {
               return { _, _ in return (destinationURL, [.removePreviousFile, .createIntermediateDirectories]) }
            }
            return .downloadDestination(downloadDestination)
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var sampleData: Data {
        return Data()
    }
}
