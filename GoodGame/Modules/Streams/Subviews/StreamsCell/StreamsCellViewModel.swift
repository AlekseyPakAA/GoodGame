//
//   StreamsCellViewModel.swift
//  GoodGame
//
//  Created by alexey.pak on 20/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

struct StreamsCellViewModel {
    
    let id: Int
    let title: String
    let subtitle: String
    
    init(stream: Stream) {
        id = stream.channel.id
        title = "\(stream.channel.key):\(stream.channel.id)"
        subtitle = stream.channel.title
    }
    
}
