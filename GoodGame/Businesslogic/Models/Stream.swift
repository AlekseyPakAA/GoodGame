//
//  Stream.swift
//  GoodGame
//
//  Created by alexey.pak on 13/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct Stream: ImmutableMappable {
    
    let id: Int
    let channel: Channel
    
    init(map: Map) throws {
        id      = try map.value("id")
        channel = try map.value("channel")
    }
    
}

