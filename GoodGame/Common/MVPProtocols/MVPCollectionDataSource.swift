//
//  MVPCollectionViewDataSource.swift
//  GoodGame
//
//  Created by alexey.pak on 16/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

protocol MVPCollectionDataSource {
    
    associatedtype ViewModelType
    
    func numberOfItems(in section: Int) -> Int
    func itemForCell(at intdex: IndexPath) -> ViewModelType
    
}

extension MVPCollectionDataSource {

}
