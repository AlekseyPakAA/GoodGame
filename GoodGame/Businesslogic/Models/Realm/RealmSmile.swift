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

	@objc dynamic var id = 0
	@objc dynamic var name = ""

	override var hashValue: Int {
		return id.hashValue
	}

	static func == (lhs: RealmSmile, rhs: RealmSmile) -> Bool {
		return lhs.id == rhs.id
	}

	override static func primaryKey() -> String? {
		return "id"
	}



}
