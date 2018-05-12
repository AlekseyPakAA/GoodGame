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
    
    let channelID: Int
    let text: String
    
    init(channelID: Int, text: String) {
        self.channelID = channelID
        self.text = text
    }
    
    init(map: Map) throws {
        channelID = try map.value("channel_id")
        text = try map.value("text")
    }
    
    func mapping(map: Map) {
        channelID >>> map["channel_id"]
        text >>> map["text"]
       
        false >>> map["hideIcon"]
        true >>> map["mobile"]
    }
    
    
}
