//
//  StreamsCell.swift
//  GoodGame
//
//  Created by alexey.pak on 10/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

class StreamsCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func configure(model: StreamsCellViewModel) {
        titleLabel.text    = model.title
        subtitleLabel.text = model.subtitle
    }
    
}
