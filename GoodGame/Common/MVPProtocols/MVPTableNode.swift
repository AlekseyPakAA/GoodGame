//
//  MVPTableNode.swift
//  GoodGame
//
//  Created by Alexey Pak on 18/05/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol MVPTableNode {

	var tableNode: ASTableNode { get }

	func insertItems(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
	func deleteItems(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
	func reloadItems(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
	func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)

    func reloadSections(sections: IndexSet, with animation: UITableViewRowAnimation)
    func reloadData()

}

extension MVPTableNode {

	func insertItems(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
		tableNode.insertRows(at: indexPaths, with: animation)
	}

	func deleteItems(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
		tableNode.deleteRows(at: indexPaths, with: animation)
	}

	func reloadItems(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
		tableNode.reloadRows(at: indexPaths, with: animation)
	}

    func reloadSections(sections: IndexSet, with animation: UITableViewRowAnimation) {
        tableNode.reloadSections(sections, with: animation)
    }

    func reloadData() {
        tableNode.reloadData()
    }

	func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
		tableNode.performBatchUpdates(updates, completion: completion)
	}

    func scrollToTop(animated: Bool) {
        let offset = CGPoint(x: tableNode.contentOffset.x, y: 0)
        tableNode.setContentOffset(offset, animated: animated)
    }

    func scrollToBottom(animated: Bool) {
        let offset = CGPoint(x: tableNode.contentOffset.x, y: tableNode.contentsRect.size.height - tableNode.bounds.size.height)
        tableNode.setContentOffset(offset, animated: animated)
    }

}
