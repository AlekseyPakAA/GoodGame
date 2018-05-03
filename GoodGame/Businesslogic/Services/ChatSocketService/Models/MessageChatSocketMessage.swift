//
// MessageChatSocketMessage.swift
// GoodGame
//
// Created by alexey.pak on 28/03/2018.
// Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct MessageChatSocketMessage: IncomingMessage {
    
    fileprivate(set) var type: ChatSocketMessageType
    let id: Int
    let text: String
    
    let channelID: Int
    
    let userID: Int
    let userName: String
    
    let color: UIColor?
    
    init(map: Map) throws {
        type = try map.value("type")
        
        id = try map.value("data.message_id")
        text = try map.value("data.text")
        
        channelID = try map.value("data.channel_id")
        
        userID = try map.value("data.user_id")
        userName = try map.value("data.user_name")
        
        color = try? map.value("data.message_color", using: HexColorTransform())
    }
    
    func mapping(map: Map) {
        type >>> map["type"]
        
        id >>> map["data.message_id"]
        text >>> map["data.text"]
        
        channelID >>> map["data.channel_id"]
        
        userID >>> map["data.user_id"]
        userName >>> map["data.user_name"]
        
        color >>> map["data.message_color"]
    }
    
}

