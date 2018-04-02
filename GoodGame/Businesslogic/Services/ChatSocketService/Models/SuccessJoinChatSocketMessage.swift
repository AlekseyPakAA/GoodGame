//
//  SuccessJoinChatSocketMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 28/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct SuccessJoinChatSocketMessage: ChatSocketMessage {
    
    fileprivate(set) var type: ChatSocketMessageType
    
    init(map: Map) throws {
        type = try map.value("type")
    }
    
    func mapping(map: Map) {
        type >>> map["type"]
    }
    
    init() {
        self.type = .successJoin
    }
    
}
