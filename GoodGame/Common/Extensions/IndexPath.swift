//
//  IndexPath.swift
//  GoodGame
//
//  Created by alexey.pak on 10/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

extension IndexPath {
    
    init(item: Int) {
        self.init(item: item, section: 0)
    }
    
    init(row: Int) {
        self.init(row: row, section: 0)
    }
    
}
