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

    func showStreamsDetail(channelid: Int) {
        let controller = PlayerAssembly.makeModule(channelid: channelid)

        context?.navigationController?.pushViewController(controller, animated: true)
    }

}
