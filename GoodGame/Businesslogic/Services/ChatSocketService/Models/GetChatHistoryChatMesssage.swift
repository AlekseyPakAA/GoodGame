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

    let channelid: Int

    init(channelid: Int) {
        self.channelid = channelid
    }

    init(map: Map) throws {
        channelid = try map.value("channel_id", using: IntegerTransform())
    }

    func mapping(map: Map) {
         channelid >>> map["channel_id"]
    }

}
