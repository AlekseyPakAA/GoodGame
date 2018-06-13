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
	var channelId: Int? {
		willSet {
			if channelId == newValue {
				return
			}
		}
	}

    init() {
         self.service = ChatSocketService()
        service?.deleate = self
    }

    func viewDidLoad() {

    }

	func connect() {
		guard let channelId = channelId else {
			return
		}

		service?.connect(channelId: channelId)
	}

    func applicationDidBecomeActive() {
		guard let channelId = channelId else {
			return
		}

        service?.connect(channelId: channelId)
    }

    func applicationWillResignActive() {
        service?.disconnect()
    }

    func updateChatCounters(message: ChannelCountersChatMessage) {

    }

    func didTouchSendButton() {
		guard let channelId = channelId else {
			return
		}

        let message = OutgoingMessageChatMessage(channelId: channelId, text: "Lorem ipsum dolor sit amet.")
        service?.send(message: message)
    }

}

extension ChatPresenter: ChatSocketServiceDelegate {

    func connectionOpened() {
		guard let channelId = channelId else {
			return
		}

        let message = GetChatHistoryChatMesssage(channelId: channelId)
        service?.send(message: message)
    }

    func connectionClosed(code: Int, reason: String, clean: Bool) {
        print(#function)
    }

    func didRecive(message: IncomingMessage) {
        if let message = message as? IncomingMessageChatMessage {
            let model = ChatMessageCellViewModel(message: message)
            items.insert(.default(model: model), at: 0)

            view?.insertMessage(with: .top)
        } else if let message = message as? ChannelCountersChatMessage {
            updateChatCounters(message: message)
        } else if let message = message as? ChatHistoryChatMesssage {
            var models: [ChatCollectionItemTypes] = message.messages.map {
                .default(model:ChatMessageCellViewModel(message: $0))
            }.reversed()

            if items.isEmpty {
                print("Chat was empty, will be added new items.")
                items.append(contentsOf: models)
            } else {
                if items[items.count - 1] == models[models.count - 1] {
                    print("The last item of chat equals the last item of new items, nothing has been changed.")
                } else if let startIndex = models.index(of: items[items.count - 1]) {
                    print("Chat was non empty, but new items contain the last item of chat and they are can be merged.")

                    models.removeSubrange((0...startIndex))
                    items.append(contentsOf: models)
                } else {
                    print("Chat was non empty, and new items don't contain the last item of chat, chat will be cleaned then will be added new items.")
                    items.removeAll()
                    items.append(contentsOf: models)
                }
            }

            view?.reloadData()
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
