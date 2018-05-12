//
//  AuthChatMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 12/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct AuthChatMessage: OutgoingMessage {
    
    var type: String = "auth"
    
    let userID: Int
    let token: String
 
    init() {
        self.userID = 0
        self.token = ""
    }
    
    init(userID: Int, token: String) {
        self.userID = userID
        self.token = token
    }
    
    init(map: Map) throws {
        userID = try map.value("user_id")
        token = try map.value("token")
    }
    
    func mapping(map: Map) {
        userID >>> map["user_id"]
        token >>> map["token"]
    }
    
    
}
