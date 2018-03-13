//
//  StreamsViewModel.swift
//  GoodGame
//
//  Created by alexey.pak on 10/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

enum StreamsCollectionItemTypes {
    case `default`, activityIndicator
}

class StreamsPresenter {
    
    private var collectionItems: [StreamsCollectionItemTypes] = []
    
    func willDisplayCell(at index: Int) {
        
    }
    
    func didPullRefreshControl() {
        
    }
    
}
