//
//  PlayerViewController.swift
//  GoodGame
//
//  Created by Alexey Pak on 04/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol PlayerView: class {

	func setVideoURL(_ url: URL)
	func play()
	func pause()

}

protocol PlayerViewControllerDelegate: class {

	func  didTouchCloseButton()

}

class PlayerViewController: ASViewController<PlayerNode> {

	var presenter: PlayerPresenter?

	weak var delegate: PlayerViewControllerDelegate?

	init() {
		let node = PlayerNode()
		super.init(node: node)

		node.videoNode.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		presenter?.viewDidLoad()

		node.overlayNode.closeButton.addTarget(self, action: #selector(didTouchCloseButton(_ :)), forControlEvents: .touchUpInside)
	}

	@objc func didTouchCloseButton(_ sender: ASDisplayNode) {
		delegate?.didTouchCloseButton()
	}

}

class PlayerNode: ASDisplayNode {

	let videoNode = ASVideoNode()
	let overlayNode = VideoNodeOverlayNode()

	override init() {
		super.init()

		backgroundColor = .black

		videoNode.addTarget(self, action: #selector(didTouchVideoNode(_:)), forControlEvents: .touchUpInside)

		automaticallyManagesSubnodes = true
	}

	@objc func didTouchVideoNode(_ sender: ASVideoNode) {
		overlayNode.state = .shown
		overlayNode.transitionLayout(withAnimation: true, shouldMeasureAsync: true)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let ratio = ASRatioLayoutSpec(ratio: 9.0 / 16.0, child: videoNode)
		let overlay = ASOverlayLayoutSpec(child: ratio, overlay: overlayNode)
		return overlay
	}

}

class VideoNodeOverlayNode: ASControlNode {

	fileprivate var state: State

	var expandButton = ASButtonNode()
	var closeButton = ASButtonNode()
	var playStopButton = PlayStopButtonNode()

	fileprivate var stamp: DispatchTime = .now()

	override init() {
		state = .hidden

		super.init()

		isHidden = true
		backgroundColor = UIColor.black.withAlphaComponent(0.45)
		alpha = 0.0

		closeButton.setImage(#imageLiteral(resourceName: "close-video-button"), for: .normal)
		closeButton.style.height = ASDimensionMake("14pt")
		closeButton.style.width =  ASDimensionMake("14pt")

		expandButton.setImage(#imageLiteral(resourceName: "expand-video-button"), for: .normal)
		expandButton.style.height = ASDimensionMake("14pt")
		expandButton.style.width =  ASDimensionMake("14pt")

		addTarget(self, action: #selector(didTouch(_:)), forControlEvents: .touchUpInside)
		closeButton.addTarget(self, action: #selector(didTouch(_:)), forControlEvents: .touchUpInside)
		expandButton.addTarget(self, action: #selector(didTouch(_:)), forControlEvents: .touchUpInside)
		playStopButton.addTarget(self, action: #selector(didTouch(_:)), forControlEvents: .touchUpInside)

		automaticallyManagesSubnodes = true
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let spacing: CGFloat = 16.0
		let inset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

		let top: ASLayoutSpec = {
			let stack = ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: .start, alignItems: .center, children: [closeButton])

			return ASInsetLayoutSpec(insets: inset, child: stack)
		}()

		let center: ASLayoutSpec = {
			let stack = ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: .center, alignItems: .center, children: [playStopButton])
			let inset = ASInsetLayoutSpec(insets: inset, child: stack)
			inset.style.flexGrow = 1

			return inset
		}()

		let bottom: ASLayoutSpec = {
			let stack = ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: .end, alignItems: .center, children: [expandButton])

			return ASInsetLayoutSpec(insets: inset, child: stack)
		}()

		return ASStackLayoutSpec(direction: .vertical, spacing: spacing, justifyContent: .spaceAround, alignItems: .stretch, children: [top, center, bottom])
	}

	override func animateLayoutTransition(_ context: ASContextTransitioning) {
		switch state {
		case .shown:
			isHidden = false

			UIView.animate(withDuration: 0.4, animations: {
				self.alpha = 1.0
			}, completion: { finished in
				context.completeTransition(finished)
				self.startProcessOfHidding()
			})
		case .hidden:
			UIView.animate(withDuration: 0.4, animations: {
				self.alpha = 0.0
			}, completion: { finished in
				self.isHidden = true
				context.completeTransition(finished)
			})
		}
	}

	@objc func didTouch(_ sender: ASDisplayNode) {
		startProcessOfHidding()
	}

	func startProcessOfHidding() {
		let stamp: DispatchTime = .now()
		self.stamp = stamp

		DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
			guard self.stamp == stamp else { return }

			self.state = .hidden
			self.transitionLayout(withAnimation: true, shouldMeasureAsync: true)
		})
	}

	enum State {
		case shown, hidden
	}
}

extension PlayerViewController: ASVideoNodeDelegate {

	func didTap(_ videoNode: ASVideoNode) {
		//do nothing
	}

	func videoNode(_ videoNode: ASVideoNode, didFailToLoadValueForKey key: String, asset: AVAsset, error: Error) {
		print(error)
	}

}

extension PlayerViewController: PlayerView {

	func setVideoURL(_ url: URL) {
		let asset = AVAsset(url: url)
		node.videoNode.asset = asset
	}

	func play() {
		node.videoNode.play()
	}

	func pause() {
		node.videoNode.pause()
	}
}
