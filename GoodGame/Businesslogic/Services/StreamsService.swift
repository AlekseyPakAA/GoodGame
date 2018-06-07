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

    func getStreams(page: Int, success: ((PaginableResponse<Stream>) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        let responseHandler = { (response: DataResponse<PaginableResponse<Stream>>) in
			if let data = response.data, let string = String(data: data, encoding: .utf8) {
				print(string)
			}

            switch response.result {
            case .success(let result):
                success?(result)
            case .failure(let error):
                failure?(error)
            }
        }

        Alamofire.request(Router.streams(page: page)).responseObject(completionHandler: responseHandler)
    }

}
