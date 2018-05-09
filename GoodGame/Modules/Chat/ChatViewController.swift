//
//  ChatViewController.swift
//  GoodGame
//
//  Created by alexey.pak on 29/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

protocol ChatView: class, MVPCollectionView {
    
}

class ChatViewController: UIViewController {

    var presenter: ChatPresenter?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            
            let nib = UINib(nibName: ChatMessageCell.reuseIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: ChatMessageCell.reuseIdentifier)
        }
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: .UIApplicationWillResignActive, object: nil)

        presenter?.viewDidLoad()
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
        
        guard let duartion = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? CGRect else {
            return
        }
        
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let frame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
            return
        }
        
        guard let duartion = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? CGRect else {
            return
        }
    }
}

extension ChatViewController: ChatView {
    
}

extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItems(in: 0) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = presenter?.itemForCell(at: indexPath) else {
            return UICollectionViewCell()
        }

        switch item {
        case .default(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageCell.reuseIdentifier, for: indexPath) as! ChatMessageCell
            cell.configure(model: model)
            return cell
        }
    }
    
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize = {
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = 60.0
            return CGSize(width: width, height: height)
        }()
        return size
    }
    
}
