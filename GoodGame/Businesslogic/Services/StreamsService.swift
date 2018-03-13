//
//  StreamsService.swift
//  GoodGame
//
//  Created by alexey.pak on 10/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper
import Alamofire

class StreamsService {
    
    func getStreams() {
        Alamofire.request("http://api2.goodgame.ru/v2/streams").responseObject { (response: DataResponse<PaginableResponse<Stream>>) in
            print(response.value)
        }
    }
    
}




