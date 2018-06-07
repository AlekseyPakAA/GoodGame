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

class PlayerViewController: ASViewController<PlayerViewControllerContentNode> {

	var presenter: PlayerPresenter?

	fileprivate var contentNode = PlayerViewControllerContentNode()
	fileprivate var videoNode: ASVideoNode {
		return contentNode.videoNode
	}

	init() {
		super.init(node: contentNode)

		videoNode.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		presenter?.viewDidLoad()
	}

}

class PlayerViewControllerContentNode: ASDisplayNode {

	let videoNode = ASVideoNode()
	let overlayNode = VideoNodeOverlayNode()

	override init() {
		super.init()

		backgroundColor = .green

		videoNode.backgroundColor = .red
		videoNode.addTarget(self, action: #selector(didTouchVideoNode(_:)), forControlEvents: .touchUpInside)

		automaticallyManagesSubnodes = true
	}

	@objc func didTouchVideoNode(_ sender: ASVideoNode) {
		overlayNode.state = .shown
		overlayNode.transitionLayout(withAnimation: true, shouldMeasureAsync: true)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		return	ASOverlayLayoutSpec(child: videoNode, overlay: overlayNode)
	}

}

class VideoNodeOverlayNode: ASControlNode {

	var state: State
	var fullScreenButton = ASButtonNode()

	fileprivate var stamp: DispatchTime = .now()

	override init() {
		state = .hidden

		super.init()

		isHidden = true
		backgroundColor = UIColor.black.withAlphaComponent(0.45)
		alpha = 0.0

		addTarget(self, action: #selector(didTouch(_:)), forControlEvents: .touchUpInside)

		fullScreenButton.backgroundColor = .red
		fullScreenButton.setTitle("FS", with: UIFont.boldSystemFont(ofSize: 14), with: .white, for: .normal)

		automaticallyManagesSubnodes = true
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let stack = ASStackLayoutSpec(direction: .horizontal,
									spacing: 16.0,
									justifyContent: .end,
									alignItems: .stretch,
									children: [fullScreenButton])

		let insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
		let inset = ASInsetLayoutSpec(insets: insets, child: stack)

		let relative = ASRelativeLayoutSpec(horizontalPosition: .end,
												verticalPosition: .end,
												sizingOption: [],
												child: inset)
		return relative
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

	@objc func didTouch(_ sender: VideoNodeOverlayNode) {
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
		print(#function)
	}

}

extension PlayerViewController: PlayerView {

	func setVideoURL(_ url: URL) {
		let asset = AVAsset(url: url)
		videoNode.asset = asset
	}

	func play() {
		videoNode.play()
	}

	func pause() {
		videoNode.pause()
	}
}
