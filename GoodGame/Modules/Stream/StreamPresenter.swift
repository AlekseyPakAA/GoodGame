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

	let streamId: Int

	init(streamId: Int) {
		self.streamId = streamId
	}

}
