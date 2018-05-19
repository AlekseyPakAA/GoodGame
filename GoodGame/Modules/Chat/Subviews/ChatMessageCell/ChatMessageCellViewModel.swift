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
    let description: String
    
    init(message: IncomingMessageChatMessage) {
        id = message.id
        title = message.userName
        description = message.text
    }
    
    static func == (lhs: ChatMessageCellViewModel, rhs: ChatMessageCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
}

