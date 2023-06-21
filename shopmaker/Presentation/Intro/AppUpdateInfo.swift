//
//  AppUpdateInfo.swift
//  KT GoodPay
//
//  Created by 임명협 on 2018. 6. 4..
/*
 * KT GoodPay version 1.0
 *
 *  Copyright ⓒ 2019 kt corp. All rights reserved.
 *
 *  This is a proprietary software of kt corp, and you may not use this file except in
 *  compliance with license agreement with kt corp. Any redistribution or use of this
 *  software, with or without modification shall be strictly prohibited without prior written
 *  approval of kt corp, and the copyright notice above does not evidence any actual or
 *  intended publication of such software.
 */


import Foundation
import UIKit

class AppUpdateInfo {
    
    var delegate: FlowManageDelegate?
    var context: UIViewController?

    func start() {
        
    }
    
    func goMarket() {
        let url = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id1450475439?mt=8")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }
    }
}
