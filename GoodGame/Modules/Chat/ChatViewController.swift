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
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            
            let nib = UINib(nibName: ChatMessageCell.reuseIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: ChatMessageCell.reuseIdentifier)
        }
    }
    
    override func viewDidLoad() {
        let layout = ChatCollectionViewFlowLayout()
        
        let size: CGSize = {
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = 60.0
            return CGSize(width: width, height: height)
        } ()
        
        layout.itemSize = size
        collectionView.collectionViewLayout = layout
    }
    
}

extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageCell.reuseIdentifier, for: indexPath) as! ChatMessageCell
        let model = ChatMessageCellViewModel(string: indexPath.row.description)
        cell.configure(model: model)
        return cell
    }
    
}

extension ChatViewController: UICollectionViewDelegateFlowLayout { }
