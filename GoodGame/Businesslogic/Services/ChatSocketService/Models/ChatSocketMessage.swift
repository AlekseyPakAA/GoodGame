//
//  ChatSocketMessage.swift
//  GoodGame
//
//  Created by alexey.pak on 27/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

protocol ChatSocketMessage: ImmutableMappable {
    
    var type: ChatSocketMessageType { get }
    
}

enum ChatSocketMessageType: String {
    case welcome, join
}
