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

    let channelid: Int
    let hidden: Bool

    init(map: Map) throws {
        channelid = try map.value("channel_id")
        hidden    = try map.value("hidden")
    }

    func mapping(map: Map) {
        channelid >>> map["channel_id"]
        hidden    >>> map["hidden"]
    }

    init(channelid: Int) {
        self.channelid = channelid
        self.hidden = false
    }

}
