//
//   StreamsCellViewModel.swift
//  GoodGame
//
//  Created by alexey.pak on 20/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

struct StreamsCellViewModel {
    
    let title: String
    let subtitle: String
    
    init(stream: Stream) {
        title    = stream.channel.key
        subtitle = stream.channel.title
    }
    
}
