//
//  ChatSocketService.swift
//  GoodGame
//
//  Created by alexey.pak on 21/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import SwiftWebSocket
import ObjectMapper
protocol ChatSocketServiceDelegate: class {
    
    func connectionOpened()
    func connectionClosed(code: Int, reason: String, clean: Bool)
    func didRecive(message: ChatSocketMessage)
    
}

class ChatSocketService {
    
    init(channelID: Int) {
        self.channelID = channelID
    }
    
    fileprivate let url   = "ws://chat.goodgame.ru:8081/chat/websocket"
    fileprivate let socket = WebSocket()
    fileprivate let channelID: Int
    
    weak var deleate: ChatSocketServiceDelegate?
    
    func connect() {
        socket.open(url)
        
        socket.event.open = { [weak self] in
            self?.deleate?.connectionOpened()
        }
        
        socket.event.close = { [weak self] (code, reason, clean) in
            self?.deleate?.connectionClosed(code: code, reason: reason, clean: clean)
        }
        
        socket.event.error = { error in
            print("error \(error)")
        }

        socket.event.message = { [weak self] message in
            guard let `self` = self else { return }
            
            guard let string = message as? String else {
                print("Received the non string message")
                return
            }
            
            guard let json: [String: Any] = Mapper<PH>.parseJSONStringIntoDictionary(JSONString: string) else {
                print("Received the non json message")
                return
            }

            guard let type = json["type"] as? String else {
                print("There is no the key \"type\" in the json")
                return
            }
            
            switch type {
            case "welcome":
                let join = JoinChatSocketMessage(channelID: self.channelID)
                self.socket.send(message: join)
            case "success_join":
                self.deleate?.connectionOpened()
            case "message":
                guard let message = try? MessageChatSocketMessage(JSON: json) else {
                    print("Unable parse \(MessageChatSocketMessage.self) from json \(string))")
                    return
                }
                self.deleate?.didRecive(message: message)
            case "channel_counters":
                guard let message = try? ChannelCountersChatSocketMessage(JSON: json) else {
                    print("Unable parse \(ChannelCountersChatSocketMessage.self) from json \(string))")
                    return
                }
                self.deleate?.didRecive(message: message)
            default:
                print("Unknown message: \(string)")
                return
            }
            
        }
    }
    
    func disconnect() {
        socket.close()
    }
    
    deinit {
        
    }
}

fileprivate extension WebSocket {
    
    func send(message: ImmutableMappable) {
        guard let jsonstring = message.toJSONString() else {
            print("Unable to parse \(message) to a json string")
            return
        }
        
        send(text: jsonstring)
    }
    
}

//Mapper want an generic parameter inherited from "Base mappable"
fileprivate class PH: Mappable {
    
    required init?(map: Map) { }
    func mapping(map: Map) { }

}
