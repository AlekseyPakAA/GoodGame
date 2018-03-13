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
    
    init(map: Map) throws {
        
        let datatransform = TransformOf<[T], [String: Any]>(fromJSON: { (value: [String: Any]?) -> [T]? in
            if let array = value?.first?.value as? [[String : Any]] {
                return array.flatMap { return T(JSON: $0) }
            } else {
                return []
            }
        }, toJSON:  { _ in return nil })

        data = try map.value("_embedded", using: datatransform)
    }
    
}

