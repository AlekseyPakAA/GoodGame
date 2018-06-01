//
//  Channel.swift
//  GoodGame
//
//  Created by alexey.pak on 15/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct Channel: ImmutableMappable {

    let id: Int
    let key: String
    let title: String

    init(map: Map) throws {
        id    = try map.value("id")
        key   = try map.value("key")
        title = try map.value("title")
    }

}
