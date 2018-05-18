//
//  MVPCollectionView.swift
//  GoodGame
//
//  Created by alexey.pak on 13/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

protocol MVPCollectionView {
    
    var collectionView: UICollectionView! { get set }
    
    func insertItems(at indexPaths: [IndexPath])
    func deleteItems(at indexPaths: [IndexPath])
    func reloadItems(at indexPaths: [IndexPath])
    func performBatchUpdates(_ updates: (()->Void)?, completion: ((Bool)->Void)?)
    
    func scrollToItem(at indexPath: IndexPath, at position: UICollectionViewScrollPosition, animated: Bool)
    func scrollToTop(animated: Bool)
    func scrollToBottom(animated: Bool)
}

extension MVPCollectionView {

    func insertItems(at indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
    }
    
    func deleteItems(at indexPaths: [IndexPath]) {
        collectionView.deleteItems(at: indexPaths)
    }
    
    func reloadItems(at indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    func performBatchUpdates(_ updates: (()->Void)?, completion: ((Bool)->Void)?) {
        collectionView.performBatchUpdates(updates, completion: completion)
    }
    
    func scrollToItem(at indexPath: IndexPath, at position: UICollectionViewScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
    }
    
    func scrollToTop(animated: Bool) {
        let offset = CGPoint(x: collectionView.contentOffset.x, y: 0)
        collectionView.setContentOffset(offset, animated: animated)
    }
    
    func scrollToBottom(animated: Bool) {
        let offset = CGPoint(x: collectionView.contentOffset.x, y:collectionView.contentSize.height - collectionView.bounds.size.height)
        collectionView.setContentOffset(offset, animated: animated)
    }
}
