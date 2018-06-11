//
//  PlayerPresenter.swift
//  GoodGame
//
//  Created by Alexey Pak on 04/06/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation
class PlayerPresenter {

	weak var view: PlayerView?
    fileprivate var playerId: String?

	fileprivate var quality: Quality = .source
	fileprivate var videoURL: URL? {
		guard let playerId = playerId else {
			return nil
		}
		return URL(string: "https://hls.goodgame.ru/hls/\(playerId)\(quality.rawValue(withPrefix: "_")).m3u8")!
	}

	func viewDidLoad() {
		guard let videoURL = videoURL else { return }

		view?.setVideoURL(videoURL)
		view?.play()
	}

}

fileprivate extension Quality {

	func rawValue(withPrefix prefix: String) -> String {
		return rawValue.isEmpty ? rawValue : prefix + rawValue
	}

}

enum Quality: String {
	case mobile = "240"
	case average = "480"
	case hight = "720"
	case source = ""
}
