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
    
    fileprivate var isVisibleLastCell: Bool = false
    
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
    
    func updateChatCounters(message: ChannelCountersChatMessage) {
        
    }
    
    func didTouchSendButton() {
        let message = OutgoingMessageChatMessage(channelID: channelID, text: "Lorem ipsum dolor sit amet.")
        service?.send(message: message)
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            isVisibleLastCell = true
        }
    }
    
    func didEndDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            isVisibleLastCell = false
        }
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
        if let message = message as? IncomingMessageChatMessage  {
            let model = ChatMessageCellViewModel(message: message)
            items.append(.default(model: model))
            
            let indexPath = IndexPath(item: items.count - 1)
            let isVisibleLastCell = self.isVisibleLastCell
            
            view?.performBatchUpdates( { [weak self] in
                self?.view?.insertItems(at: [indexPath])
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                if isVisibleLastCell {
                    self.view?.scrollToBottom(animated: true) 
                }
            })
        } else if let message = message as? ChannelCountersChatMessage {
            updateChatCounters(message: message)
        } else if let message = message as? ChatHistoryChatMesssage {
            var models: [ChatCollectionItemTypes] = message.messages.map {
                .default(model:ChatMessageCellViewModel(message: $0))
            }
            
            let insertItemsIndexPaths: [IndexPath]
            let deleteItemsIndexPaths: [IndexPath]
            
            if items.isEmpty {
                print("Chat was empty, will be added new items.")
                
                insertItemsIndexPaths = (items.count..<items.count + models.count).map {
                    IndexPath(item: $0)
                }
                deleteItemsIndexPaths = []
                items.append(contentsOf: models)
            } else {
                if items[items.count - 1] == models[models.count - 1] {
                    print("The last item of chat equals the last item of new items, nothing has been changed.")

                    insertItemsIndexPaths = []
                    deleteItemsIndexPaths = []
                } else if let startIndex = models.index(of: items[items.count - 1]) {
                    print("Chat was non empty, but new items contain the last item of chat and they are can be merged.")

                    models.removeSubrange((0...startIndex))
                    insertItemsIndexPaths = (items.count..<items.count + models.count).map {
                        IndexPath(item: $0)
                    }
                    deleteItemsIndexPaths = []
                    items.append(contentsOf: models)
                } else {
                    print("Chat was non empty, and new items don't contain the last item of chat, chat will be cleaned then will be added new items.")

                    deleteItemsIndexPaths = (0..<items.count).map {
                        IndexPath(item: $0)
                    }
                    items.removeAll()
                    
                    insertItemsIndexPaths = (items.count..<items.count + models.count).map {
                        IndexPath(item: $0)
                    }
                    items.append(contentsOf: models)
                }
            }
            
            view?.performBatchUpdates( { [weak self] in
                self?.view?.deleteItems(at: deleteItemsIndexPaths)
                self?.view?.insertItems(at: insertItemsIndexPaths)
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.view?.scrollToBottom(animated: true)
            })
        }
    }
    
}

extension ChatPresenter: MVPCollectionDataSource {
    
    typealias ViewModelType = ChatCollectionItemTypes
    
    func numberOfItems(in section: Int) -> Int {
        return items.count
    }
    
    func itemForCell(at indexPath: IndexPath) -> ChatCollectionItemTypes {
        return items[indexPath.row]
    }
    
}
