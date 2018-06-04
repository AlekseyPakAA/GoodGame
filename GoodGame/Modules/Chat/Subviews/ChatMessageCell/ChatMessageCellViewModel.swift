//
//  ChatMessageCellViewModel.swift
//  GoodGame
//
//  Created by alexey.pak on 02/04/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//
import UIKit

struct ChatMessageCellViewModel: Equatable {

	let id: Int
	let text = NSMutableAttributedString()

	fileprivate let font = UIFont.preferredFont(forTextStyle: .body)

	init(message: IncomingMessageChatMessage) {
		id = message.id

		let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font]
		let authorAttributedString = NSAttributedString(string: "\(message.userName): ", attributes: attributes)

		guard let expression = try? NSRegularExpression(pattern: ":([A-z0-9])+:") else { return }

		let matches: [NSTextCheckingResult] = {
			let nsrange = NSRange(location: 0, length: message.text.count)
			return expression.matches(in: message.text, range: nsrange).sorted(by: {lhf, rhf in
				return lhf.range.location > rhf.range.location
			})
		}()

		let descriptionAttributedString = NSMutableAttributedString(string: message.text, attributes: attributes)
		for match in matches {
			guard let range = Range<String.Index>(match.range, in: message.text) else {
				break
			}

			let smileURL: URL? = {
				let smileName = message.text[range].replacingOccurrences(of: ":", with: "")
				return SmilesManager.shared.urlForSmileWith(name: smileName)
			}()

			if let smileURL = smileURL {
				let attachment = NSTextAttachment()
				guard let data = try? Data(contentsOf: smileURL), let image = UIImage(data: data) else { return }
				attachment.image = image

				let offsetY = (font.capHeight - image.size.height) / 2
				attachment.bounds = CGRect(x: 0.0, y: offsetY, width: image.size.width, height: image.size.height)

				descriptionAttributedString.replaceCharacters(in: match.range, with: NSAttributedString(attachment: attachment))
			}
		}

		text.append(authorAttributedString)
		text.append(descriptionAttributedString)
	}

	static func == (lhs: ChatMessageCellViewModel, rhs: ChatMessageCellViewModel) -> Bool {
		return lhs.id == rhs.id
	}

}
