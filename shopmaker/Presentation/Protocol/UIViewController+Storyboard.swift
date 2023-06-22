//
//  UIViewController+Storyboard.swift
//  shopmaker
//
//  Created by LIM MAC on 2023/06/20.
//

import Foundation
import UIKit

extension UIViewController {
    static func instantiate(identifier: String? = nil) -> Self {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewControllerIdentifier = identifier ?? storyboardName
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? Self else {
            fatalError("Failed to instantiate view controller with identifier \(viewControllerIdentifier) from storyboard.")
        }
        return viewController
    }
}
