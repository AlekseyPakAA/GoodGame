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
    
    let margin: CGFloat = 16.0
    
    @IBOutlet internal weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate   = self
            
            var nib = UINib(nibName: StreamsCell.reuseIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: StreamsCell.reuseIdentifier)

            nib = UINib(nibName: StreamsPreloaderCell.reuseIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: StreamsPreloaderCell.reuseIdentifier)
            
            nib = UINib(nibName: StreamsErrorCell.reuseIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: StreamsErrorCell.reuseIdentifier)
            
            let control = UIRefreshControl()
            control.backgroundColor = .clear
            control.addTarget(self, action: #selector(didRefreshControlValueChange), for: .valueChanged)
            refreshControl = control
            
            collectionView.addSubview(control)
            
            collectionView.contentInset.top    = margin
            collectionView.contentInset.bottom = margin
        }
    }
    
    fileprivate weak var refreshControl: UIRefreshControl!
    
    @IBAction func didRefreshControlValueChange(_ sender: UIRefreshControl) {
        presenter.didPullRefreshControl()
    }
    
    let presenter: StreamsPresenter =  StreamsPresenter()
    
    override func viewDidLoad() {
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing           = margin
        collectionView.collectionViewLayout = layout
    }
    
}

extension StreamsViewController: StreamsView {
    
    func refreshControlBeginRefreshing() {
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
    }
    
    func refreshControlEndRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
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
        case .activityIndicator, .activityIndicatorFullScreen:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StreamsPreloaderCell.reuseIdentifier, for: indexPath) as! StreamsPreloaderCell
            return cell
        case .errorMessageFullScreen:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StreamsErrorCell.reuseIdentifier, for: indexPath) as! StreamsErrorCell
            return cell
        }

    }
    
}

extension StreamsViewController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willDisplayCell(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = presenter.itemForCell(at: indexPath)
        
        switch item {
        case .default, .activityIndicator:
            let width  = collectionView.frame.width - margin * 2
            let height = width / 16 * 9
            return CGSize(width: width, height: height)
        case .activityIndicatorFullScreen, .errorMessageFullScreen:
            let width  = collectionView.frame.width  - margin * 2
            let height = collectionView.frame.height - margin * 2
            return CGSize(width: width, height: height)
        }
    }
    
}
