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

    let channelID: Int

    init(channelID: Int) {
        self.channelID = channelID
    }

    init(map: Map) throws {
        channelID = try map.value("channel_id", using: IntegerTransform())
    }

    func mapping(map: Map) {
         channelID >>> map["channel_id"]
    }

}
