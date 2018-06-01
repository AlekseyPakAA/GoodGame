//
//  StreamsAssembly.swift
//  GoodGame
//
//  Created by alexey.pak on 02/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

class StreamsAssembly {

    static func makeModule() -> StreamsViewController {
        let controller = StreamsViewController.instantiateFromStoryboard()
        let presenter = StreamsPresenter()
        let router = StreamsRouter()

        controller.presenter = presenter

        router.context = controller

        presenter.view = controller
        presenter.router = router

        return controller
	}

}
