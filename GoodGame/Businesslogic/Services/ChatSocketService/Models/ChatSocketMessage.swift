//
//  ChatSocketMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 27/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

protocol ChatSocketMessage: ImmutableMappable {
    
}

protocol IncomingMessage: ChatSocketMessage {
    
    var type: ChatSocketMessageType { get }

}

protocol OutgoingMessage: ChatSocketMessage {
    
}

enum ChatSocketMessageType: String {
    case  message, channelCounters = "channel_counters"
}
