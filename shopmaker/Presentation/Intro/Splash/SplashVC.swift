//
//  ViewController.swift
//  shopmaker
//
//
//  Created by MyongHyupLim on 2023/05/18.
//  Copyright © 2022  All rights reserved.
//


import UIKit

class SplashVC: UIViewController {

    var flowManager:FlowManager? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Loading.show()
        // Do any additional setup after loading the view.
        flowManager = FlowManager(viewcontroller: self)
        flowManager?.start()
    }
}

