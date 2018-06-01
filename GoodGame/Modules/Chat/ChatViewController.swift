//
//  ChatViewController.swift
//  GoodGame
//
//  Created by alexey.pak on 29/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol ChatView: class, MVPTableNode {
    func insertMessage(with animation: UITableViewRowAnimation)
}

class ChatViewController: ASViewController<ChatViewController.ContentNode> {

    var presenter: ChatPresenter?

    fileprivate var contentNode: ContentNode = ContentNode()
    internal var tableNode: ASTableNode {
        return contentNode.tableNode
    }

	fileprivate weak var inputControl: ChatInputControl?
    fileprivate weak var inputControlBottomConstraint: NSLayoutConstraint?

    fileprivate var keyboardFrame: CGRect = .zero

    init() {
        super.init(node: contentNode)

        tableNode.dataSource = self

        tableNode.view.separatorStyle = .none
        tableNode.inverted = true

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTouchScrollView(_:)))
        tableNode.view.addGestureRecognizer(recognizer)

        if #available(iOS 11.0, *) {
            tableNode.view.contentInsetAdjustmentBehavior = .never
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotificationsObserving()
        setupInputControl()

        presenter?.viewDidLoad()
    }

    fileprivate func setupNotificationsObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)
    }

    fileprivate func setupInputControl() {
        let inputControl = ChatInputControl()
        contentNode.view.addSubview(inputControl)

        inputControl.translatesAutoresizingMaskIntoConstraints = false

        inputControl.leadingAnchor.constraint(equalTo: contentNode.view.leadingAnchor).isActive = true
        inputControl.trailingAnchor.constraint(equalTo: contentNode.view.trailingAnchor).isActive = true
        inputControlBottomConstraint = contentNode.view.bottomAnchor.constraint(equalTo: inputControl.bottomAnchor)
        inputControlBottomConstraint?.isActive = true

        self.inputControl = inputControl
    }

	override func viewDidLayoutSubviews() {
		let oldinset = tableNode.contentInset
        updateContentInsets()
		let newinset = tableNode.contentInset
		let diff = oldinset.top - newinset.top

		tableNode.contentOffset.y += diff
	}

    fileprivate func updateContentInsets() {
        let inset: UIEdgeInsets = {
            var top: CGFloat = 0
            var bottom: CGFloat = 0

            bottom += inputControl?.frame.height ?? 0
            bottom += keyboardFrame.size.height

            if #available(iOS 11.0, *) {
                top += view.safeAreaInsets.top
                bottom += view.safeAreaInsets.bottom
            } else {
                top += topLayoutGuide.length
                bottom += bottomLayoutGuide.length
            }

            return UIEdgeInsets(top: bottom, left: 0.0, bottom: top, right: 0.0)
        }()

        tableNode.contentInset = inset
        tableNode.view.scrollIndicatorInsets = inset
    }

    @objc func applicationDidBecomeActive() {
        presenter?.applicationDidBecomeActive()
    }

    @objc func applicationWillResignActive() {
        presenter?.applicationWillResignActive()
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        keyboardFrame = frame

        guard let duartion = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }

        updateContentInsets()

        tableNode.contentOffset.y -= frame.size.height

        inputControlBottomConstraint?.constant = frame.height
        UIView.animate(withDuration: duartion, animations: { [weak self] in
            self?.contentNode.view.layoutIfNeeded()
        })
    }

    @objc func keyboardWillHide(notification: Notification) {
        guard let frame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
            return
        }

        keyboardFrame = .zero

        guard let duartion = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }

        tableNode.contentOffset.y += frame.size.height

        updateContentInsets()

        inputControlBottomConstraint?.constant = 0
        UIView.animate(withDuration: duartion, animations: { [weak self] in
            self?.contentNode.view.layoutIfNeeded()
        })
    }

    @objc func didTouchScrollView(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func didTouchSendButton(_ sender: Any) {
        presenter?.didTouchSendButton()
    }

    class ContentNode: ASDisplayNode {

        let tableNode: ASTableNode = ASTableNode(style: .plain)

        override init() {
            super.init()

            automaticallyManagesSubnodes = true
        }

        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            return ASWrapperLayoutSpec(layoutElement: tableNode)
        }

    }

}

extension ChatViewController: ChatView {

    func insertMessage(with animation: UITableViewRowAnimation) {
        let indexPath = IndexPath(row: 0, section: 0)
        let indexPathsOfVisibleRows = tableNode.indexPathsForVisibleRows()

        if indexPathsOfVisibleRows.isEmpty || indexPathsOfVisibleRows.contains(indexPath) {
            tableNode.performBatchUpdates({
                self.tableNode.insertRows(at: [indexPath], with: animation)
            }, completion: {_ in
                let offset: CGPoint = {
                    let x = self.tableNode.contentOffset.x
                    let y = -self.tableNode.contentInset.top

                    return CGPoint(x: x, y: y)
                }()
                self.tableNode.setContentOffset(offset, animated: true)
            })
        } else {
            UIView.performWithoutAnimation {
                self.tableNode.insertRows(at: [indexPath], with: .top)

                guard !tableNode.view.isDecelerating else { return }

                let offset: CGPoint = {
                    let x = tableNode.contentOffset.x
                    let y = tableNode.contentOffset.y + tableNode.rectForRow(at: indexPath).height

                    return CGPoint(x: x, y: y)
                }()

                tableNode.contentOffset = offset
            }
        }

    }

}

extension ChatViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItems(in: 0) ?? 0
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellNodeBlock = { () -> ASCellNode in
            guard let item = self.presenter?.itemForCell(at: indexPath) else {
                return ASCellNode()
            }

            switch item {
            case .default(let model):
                let cell = ChatMessageCell()
                cell.configure(model: model)
                return cell
            }
        }

        return cellNodeBlock
    }

}
