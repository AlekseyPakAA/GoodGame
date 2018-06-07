//
//  OutgoingMessageChatMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 12/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct OutgoingMessageChatMessage: OutgoingMessage {

    var type: String = "send_message"

    let channelId: Int
    let text: String

    init(channelId: Int, text: String) {
        self.channelId = channelId
        self.text = text
    }

    init(map: Map) throws {
        channelId = try map.value("channel_id")
        text = try map.value("text")
    }

    func mapping(map: Map) {
        channelId >>> map["channel_id"]
        text >>> map["text"]

        false >>> map["hideIcon"]
        true >>> map["mobile"]
    }

}
