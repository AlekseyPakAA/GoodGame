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
    
    func insertItems(at indexes: [Int])
    func deleteItems(at indexes: [Int])
    func reloadItems(at indexes: [Int])
    func performBatchUpdates(_ updates: (()->Void)?, completion: ((Bool)->Void)?)
    
}

extension MVPCollectionView {
    func insertItems(at indexes: [Int]) {
        let indexPaths = indexes.map { return IndexPath(item: $0) }
        collectionView.insertItems(at: indexPaths)
    }
    
    func deleteItems(at indexes: [Int]) {
        let indexPaths = indexes.map { return IndexPath(item: $0) }
        collectionView.deleteItems(at: indexPaths)
    }
    
    func reloadItems(at indexes: [Int]) {
        let indexPaths = indexes.map { return IndexPath(item: $0) }
        collectionView.reloadItems(at: indexPaths)
    }
    
    func performBatchUpdates(_ updates: (()->Void)?, completion: ((Bool)->Void)?) {
        collectionView.performBatchUpdates(updates, completion: completion)
    }
}
