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

    let channelId: Int
    let hidden: Bool

    init(map: Map) throws {
        channelId = try map.value("channel_id")
        hidden    = try map.value("hidden")
    }

    func mapping(map: Map) {
        channelId >>> map["channel_id"]
        hidden    >>> map["hidden"]
    }

    init(channelId: Int) {
        self.channelId = channelId
        self.hidden = false
    }

}
