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

// MARK: - Private methods
private extension UIViewController {

	static func defaultInstantiateFromStoryboard<T>(type: T.Type, storyboardName: String? = nil) -> T {
		let name = String(describing: self).replacingOccurrences(of: "ViewController", with: "")
		let storyboardName = storyboardName ?? name+"Storyboard"
		let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
		let viewcontroller = storyboard.instantiateViewController(withIdentifier: name)
		//swiftlint:disable force_cast
		return viewcontroller as! T
		//swiftlint:enable force_cast
	}

	static func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
		//swiftlint:disable force_cast
		return storyboard.instantiateViewController(withIdentifier: identifier) as! T
		//swiftlint:enable force_cast
	}

}
