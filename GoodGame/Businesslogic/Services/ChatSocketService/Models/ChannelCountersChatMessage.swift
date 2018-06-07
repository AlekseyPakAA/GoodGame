//
//  ChannelCountersChatSocketMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 28/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct ChannelCountersChatMessage: IncomingMessage {

    let channelId: Int
    let clientsInChannel: Int
    let usersInChannel: Int

    init(map: Map) throws {
        channelId = try map.value("channel_id", using: IntegerTransform())
        clientsInChannel = try map.value("clients_in_channel", using: IntegerTransform())
        usersInChannel = try map.value("users_in_channel")
    }

    func mapping(map: Map) {
        channelId >>> map["channel_id"]
        clientsInChannel >>> map["clients_in_channel"]
        usersInChannel >>> map["users_in_channel"]
    }

}
