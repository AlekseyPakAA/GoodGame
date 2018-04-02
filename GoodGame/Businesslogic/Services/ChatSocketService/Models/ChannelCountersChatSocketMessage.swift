//
//  ChannelCountersChatSocketMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 28/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct ChannelCountersChatSocketMessage: ChatSocketMessage {
    
    fileprivate(set) var type: ChatSocketMessageType
    
    let channelID: Int
    let clientsInChannel: Int
    let usersInChannel: Int
    
    init(map: Map) throws {
        type = try map.value("type")
        
        channelID = try map.value("data.channel_id", using: IntegerTransform())
        clientsInChannel = try map.value("data.clients_in_channel", using: IntegerTransform())
        usersInChannel = try map.value("data.users_in_channel")
    }
    
    func mapping(map: Map) {
        type >>> map["type"]
        
        channelID >>> map["data.channel_id"]
        clientsInChannel >>> map["data.clients_in_channel"]
        usersInChannel >>> map["data.users_in_channel"]
    }
    
}

