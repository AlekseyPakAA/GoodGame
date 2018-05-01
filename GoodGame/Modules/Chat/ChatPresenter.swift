//
//  ChatPresenter.swift
//  GoodGame
//
//  Created by alexey.pak on 29/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

class ChatPresenter {

    fileprivate weak var view: ChatView?
    
    fileprivate var service: ChatSocketService?
    var channelID: Int = 0
    
    init() {
        
    }
    
    func viewDidLoad() {        
        service = ChatSocketService(channelID: channelID)
        service?.deleate = self
        service?.connect()
    }
}

extension ChatPresenter: ChatSocketServiceDelegate {
    
    func connectionOpened() {
        print(#function)
    }
    
    func connectionClosed(code: Int, reason: String, clean: Bool) {
        print(#function)
    }
    
    func didRecive(message: ChatSocketMessage) {
        switch message.type {
        case .message:
            break
        case .channelCounters:
            break
        }
    }
    
}
