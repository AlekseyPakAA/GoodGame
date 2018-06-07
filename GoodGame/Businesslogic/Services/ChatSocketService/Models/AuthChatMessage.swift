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

    let userid: Int
    let token: String

    init() {
        self.userid = 0
        self.token = ""
    }

    init(userid: Int, token: String) {
        self.userid = userid
        self.token = token
    }

    init(map: Map) throws {
        userid = try map.value("user_id")
        token = try map.value("token")
    }

    func mapping(map: Map) {
        userid >>> map["user_id"]
        token >>> map["token"]
    }

}
