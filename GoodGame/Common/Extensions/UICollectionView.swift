//
//  UICollectionView.swift
//  GoodGame
//
//  Created by Alexey Pak on 01/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit
extension UICollectionView {

	open func dequeueReusableCell<T: UICollectionViewCell>(withCellType cellType: T.Type, for indexPath: IndexPath) -> T {
		//swiftlint:disable force_cast
		return dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as! T
		//swiftlint:enable force_cast
	}

}
