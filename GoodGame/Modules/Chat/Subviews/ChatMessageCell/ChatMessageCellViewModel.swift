//
//  ChatMessageCellViewModel.swift
//  GoodGame
//
//  Created by alexey.pak on 02/04/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

struct ChatMessageCellViewModel: Equatable {
    
    let id: Int
    let title: String
    
    init(string: String) {
        id = -1
        title = string
    }
    
    init(message: MessageChatMessage) {
        id = message.id
        title = message.text
    }
    
    static func == (lhs: ChatMessageCellViewModel, rhs: ChatMessageCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
}

