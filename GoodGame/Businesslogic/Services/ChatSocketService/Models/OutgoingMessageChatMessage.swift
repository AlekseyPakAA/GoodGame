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

    let channelid: Int
    let text: String

    init(channelid: Int, text: String) {
        self.channelid = channelid
        self.text = text
    }

    init(map: Map) throws {
        channelid = try map.value("channel_id")
        text = try map.value("text")
    }

    func mapping(map: Map) {
        channelid >>> map["channel_id"]
        text >>> map["text"]

        false >>> map["hideIcon"]
        true >>> map["mobile"]
    }

}
