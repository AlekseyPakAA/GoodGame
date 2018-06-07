//
//  GetChatHistoryChatSocketMesssage.swift
//  GoodGame
//
//  Created by alexey.pak on 03/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct GetChatHistoryChatMesssage: OutgoingMessage {

    let type: String = "get_channel_history"

    let channelId: Int

    init(channelId: Int) {
        self.channelId = channelId
    }

    init(map: Map) throws {
        channelId = try map.value("channel_id", using: IntegerTransform())
    }

    func mapping(map: Map) {
         channelId >>> map["channel_id"]
    }

}
