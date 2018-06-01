//
//  ChatInputControl.swift
//  GoodGame
//
//  Created by alexey.pak on 19/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

class ChatInputControl: UIView {

    var contentView: UIView?

    init() {
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        setup()
    }

    fileprivate func setup() {
        guard let view = Bundle.main.loadNibNamed("ChatInputControl", owner: self, options: nil)?.first as? UIView else {
            return
        }

        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        contentView = view
    }

}
