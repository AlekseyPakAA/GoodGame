//
//  JoinChatSocketMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 27/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct JoinChatSocketMessage: ChatSocketMessage {
    
    fileprivate(set) var type: ChatSocketMessageType
    
    let channelID: Int
    let hidden: Bool
    
    init(map: Map) throws {
        type = try map.value("type")
        
        channelID = try map.value("data.channel_id")
        hidden    = try map.value("data.hidden")
    }
    
    func mapping(map: Map) {
        type      >>> map["type"]
        
        channelID >>> map["data.channel_id"]
        hidden    >>> map["data.hidden"]
    }
    
    init(channelID: Int) {
        self.type = .join
        self.channelID = channelID
        self.hidden = false
    }
    
}
