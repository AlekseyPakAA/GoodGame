//
//  StreamsViewController.swift
//  GoodGame
//
//  Created by alexey.pak on 10/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

protocol StreamsView: MVPCollectionView {
    
}

class StreamsViewController: UIViewController {
    
    @IBOutlet internal weak var collectionView: UICollectionView! {
        didSet {
            let margin: CGFloat = 15.0
            
            collectionView.dataSource = self
            collectionView.delegate   = self
            
            let nib = UINib(nibName: StreamsCell.reuseIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: StreamsCell.reuseIdentifier)
            
            let control = UIRefreshControl()
            control.backgroundColor = .clear
            control.addTarget(self, action: #selector(didRefreshControlValueChange), for: .valueChanged)
            collectionView.addSubview(control)
            
            collectionView.contentInset.top    = margin
            collectionView.contentInset.bottom = margin
        }
    }
    
    @IBAction func didRefreshControlValueChange(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            sender.endRefreshing()
        })
    }
    
    override func viewDidLoad() {
        StreamsService().getStreams()
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
    

    
}

extension StreamsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StreamsCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
}

extension StreamsViewController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
}
