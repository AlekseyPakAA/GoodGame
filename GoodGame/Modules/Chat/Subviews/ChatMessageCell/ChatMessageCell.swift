//
//  ChatMessageCell.swift
//  GoodGame
//
//  Created by alexey.pak on 01/04/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import AsyncDisplayKit

class ChatMessageCell: ASCellNode {

    var titleTextNode: ASTextNode  = ASTextNode()
    var descriptionTextNode: ASTextNode  = ASTextNode()

    override init() {
        super.init()

        automaticallyManagesSubnodes = true
        selectionStyle = .none

        titleTextNode.maximumNumberOfLines = 1
	}

	func configure(model: ChatMessageCellViewModel) {
		let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline)]
		titleTextNode.attributedText = NSAttributedString(string: model.title, attributes: attributes)

		if let expression = try? NSRegularExpression(pattern: ":([A-z0-9])+:") {
			let range = NSRange(location: 0, length: model.description.count)
			let matches = expression.matches(in: model.description, range: range).sorted(by: {lhf, rhf in
				return lhf.range.location > rhf.range.location
			})
		}

		descriptionTextNode.attributedText = NSAttributedString(string: model.description)
	}

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spec = ASStackLayoutSpec()

        spec.direction = .vertical
        spec.alignItems = .start
        spec.spacing = 8.0

        spec.children = [titleTextNode, descriptionTextNode]

        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        return ASInsetLayoutSpec(insets: insets, child: spec)
    }

}
