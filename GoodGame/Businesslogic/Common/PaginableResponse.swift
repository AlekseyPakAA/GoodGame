//
//  PaginableResponse.swift
//  GoodGame
//
//  Created by alexey.pak on 13/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

struct PaginableResponse<T: ImmutableMappable>: ImmutableMappable {

    let data: [T]

    let page: Int
    let numberOfPages: Int

    init(map: Map) throws {
        data          = try map.value("_embedded", using: datatransform)
        page          = try map.value("page")
        numberOfPages = try map.value("page_count")
    }

    let datatransform = TransformOf<[T], [String: Any]>(fromJSON: { (value: [String: Any]?) -> [T]? in
        if let array = value?.first?.value as? [[String: Any]] {
            return array.compactMap { return T(JSON: $0) }
        } else {
            return []
        }
    }, toJSON: { _ in return nil })

}
