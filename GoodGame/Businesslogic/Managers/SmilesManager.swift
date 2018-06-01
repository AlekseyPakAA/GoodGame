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

class SmilesManager {

	static let shared = SmilesManager()
	private init() {}

	fileprivate let url = "https://static.goodgame.ru/js/minified/global.js"

	fileprivate var dirURL: URL! {
		return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("Smiles")
	}

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
			guard let realm = try? Realm() else {
				return
			}

			_ = jscontext?.evaluateScript(script)
			guard let jsonDictionary = jscontext?.objectForKeyedSubscript("Global").toDictionary() else { return }

			guard var smiles: [MappableSmile] = {
				guard let commonSmilesArray = (jsonDictionary as AnyObject).value(forKeyPath: "Smiles") as? [[String: Any]] else {
					return nil
				}
				return try? Mapper<MappableSmile>().mapArray(JSONArray: commonSmilesArray)
				}() else {
					return
			}

			for iterator in stride(from: smiles.count - 1, to: -1, by: -1) {
				let dataset = realm.objects(RealmSmile.self)
				if let realmsmile = dataset.filter("name == %@", smiles[iterator].name).first, realmsmile.scynced {
					smiles.remove(at: iterator)
				}
			}

			let realmSmiles: [RealmSmile] = smiles.map { smile in
				let realmSmile = RealmSmile()
				realmSmile.name = smile.name

				realmSmile.img = smile.img.description
				realmSmile.imgBig = smile.imgBig.description

				if smile.animated {
					realmSmile.imgGif = smile.imgGif.description
				}

				realmSmile.animated = smile.animated

				return realmSmile
			}

			try? realm.write {
				realm.add(realmSmiles, update: true)
			}

			self.syncImages()
		}
	}

	fileprivate func syncImages() {
		guard let realm = try? Realm() else {
			return
		}

		guard (try? FileManager.default.createDirectory(atPath: dirURL.path, withIntermediateDirectories: true, attributes: nil)) != nil else {
			return
		}

		let smiles = realm.objects(RealmSmile.self)
		for smile in smiles {
			var synced = true

			if let url = URL(string: smile.img), !(loadImage(url: url)) {
				synced = false
			}

			if let url = URL(string: smile.imgBig), !(loadImage(url: url)) {
				synced = false
			}

			if smile.animated {
				if let url = URL(string: smile.imgGif), !(loadImage(url: url)) {
					synced = false
				}
			}

			try? realm.write {
				smile.scynced = synced
			}
		}
	}

	fileprivate func loadImage(url: URL) -> Bool {
		let fileURL = fileURLWith(url: url)

		guard !FileManager.default.fileExists(atPath: fileURL.path) else {
			return true
		}

		if let data = try? Data(contentsOf: url) {
			FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)
			return true
		}

		return false
	}

	fileprivate func fileURLWith(url: URL) -> URL {
		let filename = url.path.dropFirst().replacingOccurrences(of: "/", with: "_")
		return dirURL.appendingPathComponent("\(filename)")
	}

	func urlForSmileWith(name: String) -> URL? {
		guard let realm = try? Realm() else {
			return nil
		}

		let dataset = realm.objects(RealmSmile.self)
		if let realmsmile = dataset.filter("name == %@", name).first, realmsmile.scynced {
			let url = URL(string: realmsmile.imgBig)!
			return fileURLWith(url: url)
		}

		return nil
	}

}

enum SmileType {
	case `default`, big, gif
}

class RealmSmile: Object {

	@objc dynamic var name = ""

	@objc dynamic var img: String = ""
	@objc dynamic var imgBig: String = ""
	@objc dynamic var imgGif: String = ""

	@objc dynamic var scynced: Bool = false

	@objc dynamic var animated: Bool = false

	override static func primaryKey() -> String? {
		return "name"
	}

}

struct MappableSmile: ImmutableMappable {

	let name: String
	let donat: Int
	let premium: Int
	let paid: Int
	let animated: Bool
	let tag: String

	let img: URL
	let imgBig: URL
	let imgGif: URL

	let channel: String
	let channelID: Int

	init(map: Map) throws {
		name = try map.value("name")
		donat = try map.value("donat")
		premium = try map.value("premium")
		paid = try map.value("paid")
		animated = try map.value("animated")
		tag = try map.value("tag")

		img = try map.value("img", using: URLTransform())
		imgBig = try map.value("img_big", using: URLTransform())
		imgGif = try map.value("img_gif", using: URLTransform())

		channel = try map.value("channel")
		channelID = try map.value("channel_id")
	}

}
