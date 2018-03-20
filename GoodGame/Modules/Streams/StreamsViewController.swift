//
//  StreamsViewController.swift
//  GoodGame
//
//  Created by alexey.pak on 10/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

protocol StreamsView: class, MVPCollectionView {
    
    func refreshControlBeginRefreshing()
    func refreshControlEndRefreshing()
    
}

class StreamsViewController: UIViewController {
    
    @IBOutlet internal weak var collectionView: UICollectionView! {
        didSet {
            let margin: CGFloat = 15.0
            
            collectionView.dataSource = self
            collectionView.delegate   = self
            
            var nib = UINib(nibName: StreamsCell.reuseIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: StreamsCell.reuseIdentifier)

            nib = UINib(nibName: StreamsPreloaderCell.reuseIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: StreamsPreloaderCell.reuseIdentifier)
            
            let control = UIRefreshControl()
            control.backgroundColor = .clear
            control.addTarget(self, action: #selector(didRefreshControlValueChange), for: .valueChanged)
           
            collectionView.refreshControl = control
            
            collectionView.contentInset.top    = margin
            collectionView.contentInset.bottom = margin
        }
    }
    
    @IBAction func didRefreshControlValueChange(_ sender: UIRefreshControl) {
        presenter.didPullRefreshControl()
    }
    
    let presenter: StreamsPresenter =  StreamsPresenter()
    
    override func viewDidLoad() {
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 15.0

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = {
            let width  = collectionView.frame.width - margin * 2
            let height = width / 16 * 9
            return CGSize(width: width, height: height)
        }()

        layout.minimumLineSpacing           = margin
        collectionView.collectionViewLayout = layout
    }
    
}

extension StreamsViewController: StreamsView {
    
    func refreshControlBeginRefreshing() {
        collectionView.refreshControl?.beginRefreshing()
    }
    
    func refreshControlEndRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
    
}

extension StreamsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = presenter.itemForCell(at: indexPath)
        switch item {
        case .default(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StreamsCell.reuseIdentifier, for: indexPath) as! StreamsCell
            cell.configure(model: model)
            return cell
        case .activityIndicator:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StreamsPreloaderCell.reuseIdentifier, for: indexPath) as! StreamsPreloaderCell
            return cell
        }

    }
    
}

extension StreamsViewController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willDisplayCell(at: indexPath)
    }
    
}
