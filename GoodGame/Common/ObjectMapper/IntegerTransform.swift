//
//  IntegerTransform.swift
//  GoodGame
//
//  Created by alexey.pak on 29/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import ObjectMapper

class IntegerTransform: TransformType {
   
    typealias Object = Int
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Int? {
        guard let string = value as? String else { return nil }
        return Int(string)
    }
    
    func transformToJSON(_ value: Int?) -> String? {
        return String(describing: value)
    }
    
}
