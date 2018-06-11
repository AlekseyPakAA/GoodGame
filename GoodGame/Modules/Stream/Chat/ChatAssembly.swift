//
//  ChatAssembly.swift
//  GoodGame
//
//  Created by alexey.pak on 02/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

class ChatAssembly {

    static func makeModule() -> ChatViewController {
        let controller = ChatViewController()
        let presenter = ChatPresenter()

        controller.presenter = presenter
        presenter.view = controller

        return controller
    }

}
