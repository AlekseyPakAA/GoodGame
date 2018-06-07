//
//  Router.swift
//  GoodGame
//
//  Created by alexey.pak on 10/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Alamofire

enum Router: URLRequestConvertible {
	case streams(page: Int)
	case stream(id: Int)

	static let baseURLString = "http://api2.goodgame.ru/v2"

	func asURLRequest() throws -> URLRequest {
		let result: (path: String, parameters: Parameters) = {
			switch self {
			case let .streams(page):
				return ("/streams", ["page": page])
			case .stream(let id):
				return ("/streams/\(id)", [:])
			}
		}()

		let url = try Router.baseURLString.asURL()
		let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
		return try URLEncoding.default.encode(urlRequest, with: result.parameters)
	}
}
