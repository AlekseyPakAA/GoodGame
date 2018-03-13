//
//  UICollectionViewCell.swift
//  GoodGame
//
//  Created by alexey.pak on 10/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
