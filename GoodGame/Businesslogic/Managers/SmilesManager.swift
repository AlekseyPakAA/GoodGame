//
//  SmilesManager.swift
//  GoodGame
//
//  Created by alexey.pak on 26/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Alamofire
import ObjectMapper
import JavaScriptCore

class SmilesManager {
    
    static let shared = SmilesManager()
    private init() {}
    
    let url = "https://static.goodgame.ru/js/minified/global.js"
    let jscontext = JSContext()
    
    func scync() {
        Alamofire.request(url).responseString(completionHandler: { response in
            switch response.result {
            case .success(let data):
                _ = self.jscontext?.evaluateScript(data)
                guard let jsonDictionary = self.jscontext?.objectForKeyedSubscript("Global").toDictionary() else { return }
                guard let smiles: [Smile]? = {
                    guard let commonSmilesArray = (jsonDictionary as AnyObject).value(forKeyPath: "Smiles") as? [[String: Any]] else {
                        return nil
                    }
                    return try? Mapper<Smile>().mapArray(JSONArray: commonSmilesArray)
                }() else { return }
                
                print(smiles)
            case .failure(let error):
                print(error)
            }
        })
    }
    
}
