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

		guard let expression = try? NSRegularExpression(pattern: ":([A-z0-9])+:") else { return }

		let matches: [NSTextCheckingResult] = {
			let nsrange = NSRange(location: 0, length: model.description.count)
			return expression.matches(in: model.description, range: nsrange).sorted(by: {lhf, rhf in
				return lhf.range.location > rhf.range.location
			})
		}()

		let attributedDescription = NSMutableAttributedString(string: model.description)
		print("\(model.title):\(model.description)")
		for match in matches {
			guard let range = Range<String.Index>(match.range, in: model.description) else {
				break
			}

			let smileURL: URL? = {
				let smileName = model.description[range].replacingOccurrences(of: ":", with: "")
				return SmilesManager.shared.urlForSmileWith(name: smileName)
			}()

			if let smileURL = smileURL {
				let attachment = NSTextAttachment()
				guard let data = try? Data(contentsOf: smileURL), let image = UIImage(data: data) else { return }
				attachment.image = image
				attributedDescription.replaceCharacters(in: match.range, with: NSAttributedString(attachment: attachment))
			}
		}
		print("\(model.title):\(attributedDescription.string)")
		descriptionTextNode.attributedText = attributedDescription
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
