//
//  UIViewController.swift
//  GoodGame
//
//  Created by alexey.pak on 02/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func instantiateFromStoryboard(storyboardName: String? = nil) -> Self {
        return defaultInstantiateFromStoryboard(type: self, storyboardName: storyboardName)
    }

}

// MARK:- Private methods
private extension UIViewController {
    
    static func defaultInstantiateFromStoryboard<T>(type: T.Type, storyboardName: String? = nil) -> T {
        let name = String(describing: self).replacingOccurrences(of: "ViewController", with: "")
        let storyboardName = storyboardName ?? name+"Storyboard"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: name)
        return vc as! T
    }
    
    static func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
}
