//
//  StreamRouter.swift
//  GoodGame
//
//  Created by Alexey Pak on 14/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation
import UIKit

class StreamRouter {

	var context: UIViewController?

	func dissmiss(animated: Bool, completion: (() -> Void)?) {
		context?.dismiss(animated: animated, completion: completion)
	}

}
