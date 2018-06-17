//
//  StreamAssembly.swift
//  GoodGame
//
//  Created by Alexey Pak on 11/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

class StreamAssembly {

	static func makeModule(streamId: Int) -> StreamViewController {
		let player = PlayerAssembly.makeModule()
		let chat = ChatAssembly.makeModule()

		let controller = StreamViewController(player: player, chat: chat)
		let presenter = StreamPresenter(streamId: streamId, playerPresenter: player.presenter, chatPresenter: chat.presenter)
		let router = StreamRouter()

		router.context = controller

		controller.presenter = presenter
		presenter.view = controller
		presenter.router = router

		return controller
	}

}
