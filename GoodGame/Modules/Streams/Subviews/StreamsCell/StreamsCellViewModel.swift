//
//   StreamsCellViewModel.swift
//  GoodGame
//
//  Created by alexey.pak on 20/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

struct StreamsCellViewModel {
    
    let title: String
    let subtitle: String
    
    init(stream: Stream) {
        title    = "\(stream.channel.key):\(stream.channel.id)"
        subtitle = stream.channel.title
    }
    
}
