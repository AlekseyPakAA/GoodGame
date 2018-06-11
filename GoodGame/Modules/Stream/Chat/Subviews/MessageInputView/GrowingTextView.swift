//
//  GrowingTextView.swift
//  GrowingTextViewDemo
//
//  Created by Alexey Pak on 10/05/2018.
//  Copyright © 2018 Alexey Pak. All rights reserved.
//

import UIKit

class GrowingTextView: UIView {

	fileprivate var innerTextView: UITextView

	var maximumNumberOfLines = 5 {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}

	var text: String {
		get {
			return innerTextView.text
        }

        set {
            innerTextView.text = newValue
        }
    }

    override init(frame: CGRect) {
        innerTextView = UITextView(frame: .zero)
        super .init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {

        innerTextView = UITextView(frame: .zero)
        super.init(coder: aDecoder)

        setup()
    }

    fileprivate func setup() {
        addSubview(innerTextView)
		setupConstraints ()

		innerTextView.alwaysBounceVertical = true

		innerTextView.spellCheckingType = .yes
        innerTextView.autocorrectionType = .no

		innerTextView.isScrollEnabled = false

		innerTextView.font = UIFont.preferredFont(forTextStyle: .body)
		innerTextView.textContainerInset = UIEdgeInsets(top: 7.0, left: 0.0, bottom: 4.0, right: 7.0)

		NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: .UITextViewTextDidChange, object: innerTextView)
    }

	fileprivate func setupConstraints () {
		innerTextView.translatesAutoresizingMaskIntoConstraints = false

		innerTextView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		innerTextView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		innerTextView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		innerTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

    override var isFirstResponder: Bool {
		return innerTextView.isFirstResponder
    }

    override func resignFirstResponder() -> Bool {
        return innerTextView.resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        return innerTextView.becomeFirstResponder()
    }

	override var intrinsicContentSize: CGSize {
		var numberOfLines = 1
		var croppedText: NSAttributedString? = nil

		var iterator = 0
		var range = NSRange()

		while iterator < innerTextView.layoutManager.numberOfGlyphs {
			innerTextView.layoutManager.lineFragmentRect(forGlyphAt: iterator, effectiveRange: &range)

			iterator = range.upperBound
			numberOfLines += 1

			if numberOfLines == maximumNumberOfLines {
				let glyphsRange = NSRange(location: 0, length: range.upperBound)
				let charRange = innerTextView.layoutManager.characterRange(forGlyphRange: glyphsRange, actualGlyphRange: nil)
				croppedText = innerTextView.attributedText.attributedSubstring(from: charRange)
			}
		}

		let size: CGSize = {
			let contaner = CGSize(width: innerTextView.contentSize.width, height: .infinity)

			let text = croppedText ?? innerTextView.attributedText!

			var size = text.boundingRect(with: contaner, options: .usesLineFragmentOrigin, context: nil).size
			size.height += innerTextView.textContainerInset.top + innerTextView.textContainerInset.bottom
			size.height = size.height.rounded()

			return size
		}()

		if numberOfLines >= maximumNumberOfLines {
			innerTextView.isScrollEnabled = true
		} else {
			innerTextView.isScrollEnabled = false
		}

		return size
	}

	@objc func textDidChange() {
		self.invalidateIntrinsicContentSize()
	}

}
