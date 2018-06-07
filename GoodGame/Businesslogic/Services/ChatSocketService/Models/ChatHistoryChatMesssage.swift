//
//  ChatHistoryChatMesssage.swift
//  GoodGame
//
//  Created by alexey.pak on 03/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct ChatHistoryChatMesssage: IncomingMessage {

    let channelId: Int
    let messages: [IncomingMessageChatMessage]

    init(map: Map) throws {
        channelId = try map.value("channel_id")
        messages = try map.value("messages")
    }

    func mapping(map: Map) {
        channelId >>> map["channel_id"]
        messages >>> map["messages"]
    }

}
