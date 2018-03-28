//
//  WelcomeChatSocketMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 27/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct WelcomeChatSocketMessage: ChatSocketMessage {
    
    fileprivate(set) var type: ChatSocketMessageType

    let protocolVersion: String
    let serverIdent: String

    init(map: Map) throws {
        type = try map.value("type")
        
        protocolVersion = try map.value("data.protocolVersion")
        serverIdent     = try map.value("data.serverIdent")
    }
    
}
