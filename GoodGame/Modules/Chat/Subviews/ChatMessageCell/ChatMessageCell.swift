//
//  ChatMessageCell.swift
//  GoodGame
//
//  Created by alexey.pak on 01/04/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(model: ChatMessageCellViewModel) {
        titleLabel.text = model.title
    }
    
}
