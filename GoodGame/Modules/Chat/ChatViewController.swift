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

class ChatViewController: ASViewController<ChatViewController.ContentNode>  {
    
    var presenter: ChatPresenter?

    fileprivate var collectionViewOrgignalIndicatorInsets: UIEdgeInsets!
    fileprivate var collectionViewOrgignalInsets: UIEdgeInsets!
    
    var contentNode: ContentNode
    var tableNode: ASTableNode {
        return contentNode.tableNode
    }
    
//    @IBOutlet fileprivate weak var messageInputViewBottomConstarint: NSLayoutConstraint!
//    @IBOutlet fileprivate weak var messageInputViewContainer: UIView!
//    @IBOutlet fileprivate weak var messageInputView: GrowingTextView!
    
    init() {
        contentNode = ContentNode()
        super.init(node: contentNode)
        
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.view.separatorStyle = .none
        tableNode.inverted = true
        
        if #available(iOS 11.0, *) {
            tableNode.view.contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)

        presenter?.viewDidLoad()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        let inset: UIEdgeInsets = {
            if #available(iOS 11.0, *) {
                let top = view.safeAreaInsets.bottom
                let bottom = view.safeAreaInsets.top
                
                return UIEdgeInsets(top: top, left: 0.0, bottom: bottom, right: 0.0)
            } else {
                let top = topLayoutGuide.length
                let bottom = topLayoutGuide.length
                
                return UIEdgeInsets(top: top, left: 0.0, bottom: bottom, right: 0.0)
            }
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
        
        guard let duartion = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        tableNode.contentInset.bottom = collectionViewOrgignalInsets.bottom + frame.height
        tableNode.view.scrollIndicatorInsets.bottom = collectionViewOrgignalIndicatorInsets.bottom + frame.height
        tableNode.contentOffset = {
            let x = tableNode.contentOffset.x
            let y = tableNode.contentOffset.y + frame.height
            return CGPoint(x: x, y: y)
        }()
        
//        messageInputViewBottomConstarint.constant = frame.height
//        UIView.animate(withDuration: duartion, animations: { [weak self] in
//            self?.view.layoutIfNeeded()
//        })
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let frame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
            return
        }
        
        guard let duartion = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        tableNode.contentOffset = {
            let x = tableNode.contentOffset.x
            let y = tableNode.contentOffset.y - frame.height
            return CGPoint(x: x, y: y)
        }()

        tableNode.contentInset.bottom = collectionViewOrgignalInsets.bottom
        tableNode.view.scrollIndicatorInsets.bottom = collectionViewOrgignalIndicatorInsets.bottom
        
//        messageInputViewBottomConstarint.constant = 0
//        UIView.animate(withDuration: duartion, animations: {[weak self] in
//            self?.view.layoutIfNeeded()
//        })
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

extension ChatViewController: ASTableDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        presenter?.willDisplayCell(at: indexPath)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        presenter?.didEndDisplayCell(at: indexPath)
//    }

}



