//
//  MVPTableView.swift
//  GoodGame
//
//  Created by Alexey Pak on 18/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol MVPAsyncTableView {

	var tableView: ASTableNode! { get set }

	func insertItems(at indexPaths: [IndexPath])
	func deleteItems(at indexPaths: [IndexPath])
	func reloadItems(at indexPaths: [IndexPath])
	func performBatchUpdates(_ updates: (()->Void)?, completion: ((Bool)->Void)?)

}

extension MVPAsyncTableView {

	func insertItems(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
		tableView.insertRows(at: indexPaths, with: animation)
	}

	func deleteItems(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
		tableView.deleteRows(at: indexPaths, with: animation)
	}

	func reloadItems(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
		tableView.reloadRows(at: indexPaths, with: animation)
	}

	func performBatchUpdates(_ updates: (()->Void)?, completion: ((Bool)->Void)?) {
		tableView.performBatchUpdates(updates, completion: completion)
	}
	
}

