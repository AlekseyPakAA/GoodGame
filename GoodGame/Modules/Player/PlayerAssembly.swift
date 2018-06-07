//
//  PlayerAssembly.swift
//  GoodGame
//
//  Created by Alexey Pak on 04/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

class PlayerAssembly {

	static func makeModule(channelid: Int) -> PlayerViewController {
		let controller = PlayerViewController()
		let presenter = PlayerPresenter(channelid: channelid)

		controller.presenter = presenter
		presenter.view = controller

		return controller
	}

}
