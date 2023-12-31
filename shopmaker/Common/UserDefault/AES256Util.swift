//
//  AES256Util.swift
//  shopmaker
//
//
//  Created by MyongHyupLim on 2023/05/18.
//  Copyright © 2022  All rights reserved.
//


import Foundation
import CryptoSwift

class AES256Util {
    //키값 32바이트: AES256(24bytes: AES192, 16bytes: AES128)
    private static let SECRET_KEY = "01234567890123450123456789012345"
    private static let IV = "0123456789012345"
 
    static func encrypt(data: String) -> String {
        guard !data.isEmpty else { return "" }
        return try! getAESObject().encrypt(data.bytes).toBase64() ?? ""
    }
 
    static func decrypt(encoded: String) -> String {
        let datas = Data(base64Encoded: encoded)
 
        guard datas != nil else {
            return ""
        }
 
        let bytes = datas!.bytes
        let decode = try! getAESObject().decrypt(bytes)
 
        return String(bytes: decode, encoding: .utf8) ?? ""
    }
 
    private static func getAESObject() -> AES{
        let keyDecodes : Array<UInt8> = Array(SECRET_KEY.utf8)
        let ivDecodes : Array<UInt8> = Array(IV.utf8)
        let aesObject = try! AES(key: keyDecodes, blockMode: CBC(iv: ivDecodes), padding: .pkcs5)
 
        return aesObject
    }
}
