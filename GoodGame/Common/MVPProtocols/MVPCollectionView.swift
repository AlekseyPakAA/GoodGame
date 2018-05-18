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
	
}
