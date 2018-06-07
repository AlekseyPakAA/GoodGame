//
//  StreamsRouter.swift
//  GoodGame
//
//  Created by alexey.pak on 01/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

class StreamsRouter {

    var context: UIViewController?

    func showStreamsDetail(streamId: Int) {
		StreamsService().getStream(id: streamId, success: { stream in
			let controller = PlayerAssembly.makeModule(playerId: stream.channel.playerId)

			self.context?.navigationController?.pushViewController(controller, animated: true)
		})
    }

}
