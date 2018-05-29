//
//  RealmSmile.swift
//  GoodGame
//
//  Created by Alexey Pak on 29/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSmile: Object {

	@objc dynamic var name = ""

    @objc dynamic var img: String = ""
    @objc dynamic var imgBig: String = ""
    @objc dynamic var imgGif: String = ""
    
	override static func primaryKey() -> String? {
		return "name"
	}



}
