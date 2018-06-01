//
// MessageChatSocketMessage.swift
// GoodGame
//
// Created by alexey.pak on 28/03/2018.
// Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct IncomingMessageChatMessage: IncomingMessage, Equatable {

    let id: Int
    let text: String

    let channelID: Int

    let userID: Int
    let userName: String

    let color: UIColor?

    init(map: Map) throws {
        id = try map.value("message_id")
        text = try map.value("text")

        channelID = try map.value("channel_id")

        userID = try map.value("user_id")
        userName = try map.value("user_name")

        color = try? map.value("message_color", using: HexColorTransform())
    }

    func mapping(map: Map) {
        id >>> map["message_id"]
        text >>> map["text"]

        channelID >>> map["channel_id"]

        userID >>> map["user_id"]
        userName >>> map["user_name"]

        color >>> map["message_color"]
    }

    static func == (lhs: IncomingMessageChatMessage, rhs: IncomingMessageChatMessage) -> Bool {
        return lhs.id == rhs.id
    }

}
