//
//  ChatMessageCell.swift
//  GoodGame
//
//  Created by alexey.pak on 01/04/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import AsyncDisplayKit
import Kingfisher

class ChatMessageCell: ASCellNode {

	var textNode: ASTextNode  = ASTextNode()

	override init() {
		super.init()

		automaticallyManagesSubnodes = true
		selectionStyle = .none
	}

	func configure(model: ChatMessageCellViewModel) {
		textNode.attributedText = model.text
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
		return ASInsetLayoutSpec(insets: insets, child: textNode)
	}

}
