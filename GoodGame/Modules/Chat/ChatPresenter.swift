//
//  ChatPresenter.swift
//  GoodGame
//
//  Created by alexey.pak on 29/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

enum ChatCollectionItemTypes {
    case `default`(model: ChatMessageCellViewModel)
}

class ChatPresenter {

    weak var view: ChatView?
    fileprivate var items: [ChatCollectionItemTypes] = []
    
    fileprivate var service: ChatSocketService?
    fileprivate var channelID: Int
    
    init(channelID: Int) {
        self.channelID = channelID
        
        self.service = ChatSocketService()
        service?.deleate = self
    }
    
    func viewDidLoad() {        
        service?.connect(channelID: channelID)
    }
    
    func applicationDidBecomeActive() {
        service?.connect(channelID: channelID)
    }
    
    func applicationWillResignActive() {
        service?.disconnect()
    }
    
}

extension ChatPresenter: ChatSocketServiceDelegate {
    
    func connectionOpened() {
        print(#function)
    }
    
    func connectionClosed(code: Int, reason: String, clean: Bool) {
        print(#function)
    }
    
    func didRecive(message: IncomingMessage) {
        switch message.type {
        case .message:
            guard let message = message as? MessageChatSocketMessage else { return }
            
            let model = ChatMessageCellViewModel(message: message)
            items.append(.default(model: model))
            
            let indexPath = IndexPath(item: items.count - 1)
            view?.insertItems(at: [indexPath])
        case .channelCounters:
            break
        }
    }
    
}

extension ChatPresenter: MVPCollectionViewDataSource {
    
    typealias ViewModelType = ChatCollectionItemTypes
    
    func numberOfItems(in section: Int) -> Int {
        return items.count
    }
    
    func itemForCell(at indexPath: IndexPath) -> ChatCollectionItemTypes {
        return items[indexPath.row]
    }
    
}
