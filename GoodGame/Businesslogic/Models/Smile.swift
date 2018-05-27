//
//  Smile.swift
//  GoodGame
//
//  Created by alexey.pak on 27/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct Smile: ImmutableMappable {
    
    let id: Int
    let name: String
    let donat: Int
    let premium: Int
    let paid: Int
    let animated: Bool
    let tag: String
    
    let img: URL
    let imgBig: URL
    let imgGif: URL
    
    let channel: String
    let channelID: Int
    
    init(map: Map) throws {
        id = try map.value("id", using: IntegerTransform())
        
        name = try map.value("name")
        donat = try map.value("donat")
        premium = try map.value("premium")
        paid = try map.value("paid")
        animated = try map.value("animated")
        tag = try map.value("tag")
        
        img = try map.value("img", using: URLTransform())
        imgBig = try map.value("img_big", using: URLTransform())
        imgGif = try map.value("img_gif", using: URLTransform())
        
        channel = try map.value("channel")
        channelID = try map.value("channel_id")
    }
    
}
