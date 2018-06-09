//
//  PlayStopButtonNode.swift
//  GoodGame
//
//  Created by Alexey Pak on 08/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class PlayStopButtonNode: ASButtonNode {

	fileprivate weak var playStopView: PlayStopView?

	override init() {
		super.init()

		let playStopView = PlayStopView(frame: bounds)
		self.view.addSubview(playStopView)
		self.playStopView = playStopView

		playStopView.translatesAutoresizingMaskIntoConstraints = false
		playStopView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		playStopView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

		playStopView.rectsize = CGSize(width: 9.0, height: 33.0)
		playStopView.space = 9.0

		style.height = ASDimension(unit: .points, value: 44.0)
		style.width = ASDimension(unit: .points, value: 44.0)

		addTarget(self, action: #selector(didTouch), forControlEvents: .touchUpInside)
	}

	@objc func didTouch() {
		playStopView?.trasition = playStopView?.trasition == 1 ? 0 : 1
	}

}

class PlayStopView: UIView {

	var trasition: CGFloat {
		get {
			return (layer as? PlayStopLayer)?.trasition ?? 0.0
		}

		set {
			(layer as? PlayStopLayer)?.trasition = newValue
		}
	}

	var rectsize: CGSize {
		get {
			return (layer as? PlayStopLayer)?.rectsize ?? .zero
		}

		set {
			(layer as? PlayStopLayer)?.rectsize = newValue
		}
	}

	var space: CGFloat {
		get {
			return (layer as? PlayStopLayer)?.space ?? 0.0
		}

		set {
			(layer as? PlayStopLayer)?.space = newValue
		}
	}

	override var intrinsicContentSize: CGSize {
		return CGSize(width: rectsize.width * 2 + space, height: rectsize.height)
	}

	override class var layerClass: AnyClass {
		return PlayStopLayer.self
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = UIColor.clear
		(layer as? PlayStopLayer)?.contentsScale = UIScreen.main.scale
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

class PlayStopLayer: CALayer {

	@NSManaged var trasition: CGFloat //0 - pause shape, 1 - play shape

	@NSManaged var rectsize: CGSize
	@NSManaged var space: CGFloat

	fileprivate var center: CGPoint {
		return CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
	}

	override init(layer: Any) {
		super.init(layer: layer)

		guard let layer = layer as? PlayStopLayer else { return }
		trasition = layer.trasition
	}

	override init() {
		super.init()

		setNeedsDisplay()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override class func needsDisplay(forKey key: String) -> Bool {
		if key == "trasition" || key == "rectsize" || key == "space" {
			return true
		}

		return super.needsDisplay(forKey: key)
	}

	override func action(forKey event: String) -> CAAction? {
		if event == "trasition" {
			let animation = CABasicAnimation(keyPath: event)
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
			animation.fromValue = presentation()?.value(forKey: event)
			return animation
		}

		return super.action(forKey: event)
	}

	override func draw(in ctx: CGContext) {
		ctx.setFillColor(UIColor.white.cgColor)

		// first square
		ctx.beginPath()

		var start = CGPoint(x: center.x - space * 1.5, y: center.y - rectsize.height / 2)
		ctx.move(to: start)

		let centerA: CGPoint = {
			let start = start
			let end = CGPoint(x: start.x + rectsize.width + space + rectsize.width, y: start.y + rectsize.height * 0.5)

			return CGPoint(x: (start.x + end.x) / 2.0, y: (start.y + end.y) / 2.0)
		}()

		let centerB: CGPoint = {
			var start = start
			start.y += rectsize.height
			let end = CGPoint(x: start.x + rectsize.width + space + rectsize.width, y: start.y - rectsize.height * 0.5)

			return CGPoint(x: (start.x + end.x) / 2.0, y: (start.y + end.y) / 2.0)
		}()

		start.x += rectsize.width
		ctx.addLine(to: CGPoint(x: start.x + space * 0.5 * trasition, y: start.y - (start.y - centerA.y) * trasition))

		start.y += rectsize.height
		ctx.addLine(to: CGPoint(x: start.x + space * 0.5 * trasition, y: start.y - (start.y - centerB.y) * trasition))

		start.x -= rectsize.width
		ctx.addLine(to: start)

		ctx.closePath()

		ctx.drawPath(using: .fill)

		// second square
		ctx.beginPath()

		start = CGPoint(x: center.x + space * 0.5, y: center.y - rectsize.height / 2)

		ctx.move(to: CGPoint(x: start.x - space * 0.5 * trasition, y:  start.y - (start.y - centerA.y) * trasition))

		start.x += rectsize.width
		ctx.addLine(to: CGPoint(x: start.x, y: start.y + (rectsize.height * 0.5 * trasition)))

		start.y += rectsize.height
		ctx.addLine(to: CGPoint(x: start.x, y: start.y - (rectsize.height * 0.5 * trasition)))

		start.x -= rectsize.width
		ctx.addLine(to: CGPoint(x: start.x - space * 0.5 * trasition, y: start.y - (start.y - centerB.y) * trasition))

		ctx.closePath()

		ctx.drawPath(using: .fill)
	}

}
