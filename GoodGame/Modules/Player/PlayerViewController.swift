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

		backgroundColor = .white

		videoNode.addTarget(self, action: #selector(didTouchVideoNode(_:)), forControlEvents: .touchUpInside)

		automaticallyRelayoutOnSafeAreaChanges = true
		automaticallyManagesSubnodes = true
	}

	@objc func didTouchVideoNode(_ sender: ASVideoNode) {
		overlayNode.state = .shown
		overlayNode.transitionLayout(withAnimation: true, shouldMeasureAsync: true)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let overlay = ASOverlayLayoutSpec(child: videoNode, overlay: overlayNode)
		return ASInsetLayoutSpec(insets: safeAreaInsets, child: overlay)
	}

}

class VideoNodeOverlayNode: ASControlNode {

	var state: State
	var fullScreenButton = ASButtonNode()
	var qualityPickerButton = ASButtonNode()
	var closeButton = ASButtonNode()
	var playStopButton = PlayStopButtonNode()

	fileprivate var stamp: DispatchTime = .now()

	override init() {
		state = .hidden

		super.init()

		isHidden = true
		backgroundColor = UIColor.black.withAlphaComponent(0.45)
		alpha = 0.0

		addTarget(self, action: #selector(didTouch(_:)), forControlEvents: .touchUpInside)

		fullScreenButton.setTitle("FS", with: UIFont.boldSystemFont(ofSize: 14), with: .white, for: .normal)
		qualityPickerButton.setTitle("QP", with: UIFont.boldSystemFont(ofSize: 14), with: .white, for: .normal)
		closeButton.setTitle("CL", with: UIFont.boldSystemFont(ofSize: 14), with: .white, for: .normal)

		automaticallyManagesSubnodes = true
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let spacing: CGFloat = 16.0
		let inset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

		let top: ASLayoutSpec = {
			let stack = ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: .end, alignItems: .center, children: [closeButton])

			return ASInsetLayoutSpec(insets: inset, child: stack)
		}()

		let center: ASLayoutSpec = {
			let stack = ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: .center, alignItems: .center, children: [playStopButton])
			let inset = ASInsetLayoutSpec(insets: inset, child: stack)
			inset.style.flexGrow = 1

			return inset
		}()

		let bottom: ASLayoutSpec = {
			let stack = ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: .end, alignItems: .center, children: [fullScreenButton])

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
