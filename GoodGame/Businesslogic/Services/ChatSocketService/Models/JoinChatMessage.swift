//
//  JoinChatSocketMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 27/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct JoinChatMessage: OutgoingMessage {
    
    let type: String = "join"

    let channelID: Int
    let hidden: Bool
    
    init(map: Map) throws {
        channelID = try map.value("channel_id")
        hidden    = try map.value("hidden")
    }
    
    func mapping(map: Map) {
        channelID >>> map["channel_id"]
        hidden    >>> map["hidden"]
    }
    
    init(channelID: Int) {
        self.channelID = channelID
        self.hidden = false
    }
    
}
