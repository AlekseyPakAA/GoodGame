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
		let controller = StreamAssembly.makeModule(streamId: streamId)
		context?.present(controller, animated: true)
    }

}
