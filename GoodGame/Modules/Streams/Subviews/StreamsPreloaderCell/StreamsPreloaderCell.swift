//
//  StreamsPreloaderCell.swift
//  GoodGame
//
//  Created by alexey.pak on 20/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

class StreamsPreloaderCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.startAnimating()
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        activityIndicator.stopAnimating()
    }

}
