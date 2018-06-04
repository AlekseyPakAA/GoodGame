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

    func showStreamsDetail(channelID: Int) {
        let controller = PlayerAssembly.makeModule(channelID: channelID)

        context?.navigationController?.pushViewController(controller, animated: true)
    }

}
