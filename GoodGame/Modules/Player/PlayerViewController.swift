//
//  PlayerViewController.swift
//  GoodGame
//
//  Created by Alexey Pak on 04/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PlayerViewController: ASViewController<PlayerViewController.ContentNode> {

	fileprivate var contentNode: ContentNode = ContentNode()
	fileprivate var videoNode: ASVideoNode {
		return contentNode.videoNode
	}

	init() {
		super.init(node: contentNode)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	class ContentNode: ASDisplayNode {

		let videoNode: ASVideoNode = ASVideoNode()

		override init() {
			super.init()

			backgroundColor = .green
			videoNode.backgroundColor = .red

			let url = URL(string: "blob:https://goodgame.ru/14cecff4-1dc5-403e-bb4b-65b6692927d6")!
			let asset = AVAsset(url: url)

			videoNode.asset = asset

			automaticallyManagesSubnodes = true
		}

		override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
			let wrapperLayoutSpec = ASWrapperLayoutSpec(layoutElement: videoNode)

			let insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
			let insetLayoutSpec = ASInsetLayoutSpec(insets: insets, child: wrapperLayoutSpec)

			return insetLayoutSpec
		}

	}

}
