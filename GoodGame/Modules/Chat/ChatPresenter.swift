//
//  ChatPresenter.swift
//  GoodGame
//
//  Created by alexey.pak on 29/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

enum ChatCollectionItemTypes: Equatable {
    static func == (lhs: ChatCollectionItemTypes, rhs: ChatCollectionItemTypes) -> Bool {
        switch (lhs, rhs) {
        case (.default(let lhsmodel), .default(let rhsmodel)):
            return lhsmodel == rhsmodel
        }
    }
    
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
        let message = GetChatHistoryChatMesssage(channelID: channelID)
        service?.send(message: message)
    }
    
    func connectionClosed(code: Int, reason: String, clean: Bool) {
        print(#function)
    }
    
    func didRecive(message: IncomingMessage) {
        if let message = message as? MessageChatMessage  {
            let model = ChatMessageCellViewModel(message: message)
            items.append(.default(model: model))
            
            let indexPath = IndexPath(item: items.count - 1)
            view?.insertItems(at: [indexPath])
        } else if let message = message as? ChannelCountersChatMessage {
            return
        } else if let message = message as? ChatHistoryChatMesssage {
            let models: [ChatCollectionItemTypes] = message.messages.map {
                .default(model:ChatMessageCellViewModel(message: $0))
            }
            
            let insertItemsIndexPaths: [IndexPath]  //(items.count..<items.count + models.count).map { IndexPath(item: $0) }
            let deleteItemsIndexPaths: [IndexPath] //(items.count..<items.count + models.count).map { IndexPath(item: $0) }
            
            if items.isEmpty {
                items.append(contentsOf: models)
                insertItemsIndexPaths = (items.count..<items.count + models.count).map { IndexPath(item: $0) }
                deleteItemsIndexPaths = []
            } else {
                if let startIndex = models.index(of: items[items.count - 1]) {
                    
                } else {
                    
                }
                insertItemsIndexPaths = []
                deleteItemsIndexPaths = []
            }
            items.append(contentsOf: models)
            
            view?.performBatchUpdates( { [weak self] in
                self?.view?.deleteItems(at: deleteItemsIndexPaths)//(at: insertItemsIndexPaths)
                self?.view?.insertItems(at: insertItemsIndexPaths)
            }, completion: nil)
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
