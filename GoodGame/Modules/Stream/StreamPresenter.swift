//
//  StreamPresenter.swift
//  GoodGame
//
//  Created by Alexey Pak on 11/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

class StreamPresenter {

	weak var view: StreamView?
	weak var playerPresenter: PlayerPresenter?
	weak var chatPresenter: ChatPresenter?

	var router: StreamRouter?

	fileprivate let streamsService = StreamsService()

	let streamId: Int
	var stream: Stream?

	init(streamId: Int, playerPresenter: PlayerPresenter?, chatPresenter: ChatPresenter?) {
		self.streamId = streamId
		self.playerPresenter = playerPresenter
		self.chatPresenter = chatPresenter
	}

	func viewDidLoad() {
		//show progress
		streamsService.getStream(id: streamId, success: {[weak self] stream in
			guard let `self` = self else { return }
			self.playerPresenter?.playerId = stream.channel.playerId
			self.playerPresenter?.play()

			self.chatPresenter?.channelId = stream.channel.id
			self.chatPresenter?.connect()
		}, failure: { error in
			//TO DO: Handle error
		})
	}

	func didTouchCloseButton() {
		router?.dissmiss(animated: true, completion: nil)
	}

}
