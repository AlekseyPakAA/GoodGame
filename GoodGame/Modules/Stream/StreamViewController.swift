//
//  StreamViewController.swift
//  GoodGame
//
//  Created by Alexey Pak on 11/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol StreamView: class {

}

class StreamViewController: ASViewController<StreamNode> {

	override var prefersStatusBarHidden: Bool {
		return true
	}

	var presenter: StreamPresenter?

	init(player: PlayerViewController, chat: ChatViewController) {
		let node = StreamNode(playerNode: player.node, chatNode: chat.node)

		super.init(node: node)

		addChildViewController(player)
		addChildViewController(chat)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		presenter?.viewDidLoad()
	}

}

extension StreamViewController: StreamView {

}

class StreamNode: ASDisplayNode {

	let playerNode: PlayerNode
	let chatNode: ChatNode

	init(playerNode: PlayerNode, chatNode: ChatNode) {
		self.playerNode = playerNode
		self.chatNode = chatNode

		super.init()
		backgroundColor = .white

		chatNode.style.flexGrow = 1.0

		automaticallyRelayoutOnSafeAreaChanges = true
		automaticallyManagesSubnodes = true
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let stack = ASStackLayoutSpec(direction: .vertical, spacing: 0.0, justifyContent: .spaceBetween, alignItems: .stretch, children: [playerNode, chatNode])
		return ASInsetLayoutSpec(insets: safeAreaInsets, child: stack)

	}

}
