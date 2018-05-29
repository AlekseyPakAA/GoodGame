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
import RealmSwift
import Kingfisher

class SmilesManager {
    
    static let shared = SmilesManager()
    private init() {}
    
    fileprivate let url = "https://static.goodgame.ru/js/minified/global.js"
    
    func scync() {
        Alamofire.request(url).responseString(completionHandler: { response in
            switch response.result {
            case .success(let data):
				self.handleReceivedScript(script: data)
			case .failure(let error):
                print(error)
            }
        })
    }

	fileprivate func handleReceivedScript(script: String) {
        DispatchQueue.global(qos: .utility).async {
            let jscontext = JSContext()
            let realm = try? Realm()
            
            _ = jscontext?.evaluateScript(script)
            guard let jsonDictionary = jscontext?.objectForKeyedSubscript("Global").toDictionary() else { return }
            
            guard let smiles: [Smile] = {
                guard let commonSmilesArray = (jsonDictionary as AnyObject).value(forKeyPath: "Smiles") as? [[String: Any]] else {
                    return nil
                }
                return try? Mapper<Smile>().mapArray(JSONArray: commonSmilesArray)
            }() else {
                return
            }
            
            let realmSmiles: [RealmSmile] = smiles.map { smile in
                let realmSmile = RealmSmile()
                realmSmile.name = smile.name
                
                realmSmile.img = smile.img.description
                realmSmile.imgBig = smile.img.description
                realmSmile.imgGif = smile.img.description
                
                return realmSmile
            }
            
            try? realm?.write {
                realm?.add(realmSmiles, update: true)
            }
            
            self.syncImages()
        }
	}
    
    fileprivate func syncImages() {
        let realm = try? Realm()
        
        guard let smiles = realm?.objects(RealmSmile.self) else { return }
        for smile in smiles {
            var names:[String] = []

            names.append(fileNameForImage(type: .small, name: smile.img))
            names.append(fileNameForImage(type: .big, name: smile.imgBig))
            names.append(fileNameForImage(type: .gif, name: smile.imgGif))
            
            
        }
    }
    
    fileprivate func fileNameForImage(type: ImageType, name: String) -> String {
        switch type {
        case .small:
            return "\(name).png"
        case .big:
            return "\(type)-\(name).png"
        case .gif:
            return "\(type)-\(name).gif"
        }
    }

}


fileprivate enum ImageType: String {
    case small, big, gif
}
