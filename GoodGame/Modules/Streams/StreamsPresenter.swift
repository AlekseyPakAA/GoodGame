//
//  StreamsViewModel.swift
//  GoodGame
//
//  Created by alexey.pak on 10/03/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation

enum StreamsCollectionItemTypes {
    case `default`(model: StreamsCellViewModel)
    case activityIndicator
    case activityIndicatorFullScreen
    case errorMessageFullScreen
}

enum StreamsPresenterState {
    case empty, emptyProgress, emptyError, emptyData, data, pageProgress, refresh, end
}

class StreamsPresenter {
    
    fileprivate var items: [StreamsCollectionItemTypes] = []
    fileprivate let streamsService = StreamsService()
    
    fileprivate var page: Int = 1 {
        didSet {
            print("page: \(page)")
        }
    }
    
    fileprivate var state: StreamsPresenterState = .empty {
        didSet {
            print("page: \(state)")
        }
    }
    
    weak var view: StreamsView?
    
    func viewDidLoad() {
        refresh()
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            loadNextPage()
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
         view?.showDetailScreen()
    }

    
    func didPullRefreshControl() {
        refresh()
    }
    
}

fileprivate extension StreamsPresenter {
    
    func refresh() {
        switch state {
        case .empty, .emptyData:
            state = .emptyProgress
            view?.refreshControlBeginRefreshing()
            
            streamsService.getStreams(page: 1, success: { [weak self] result in
                guard let `self` = self else { return }
                
                let newitems: [StreamsCollectionItemTypes] = result.data.map {
                    let model = StreamsCellViewModel(stream: $0)
                    return .default(model: model)
                }
                self.items.append(contentsOf: newitems)
                
                if result.numberOfPages == self.page {
                    self.state = .end
                } else {
                    self.state = .data
                    self.items.append(.activityIndicator)
                }
                
                let indexPaths = (0..<self.items.count).map { return IndexPath(item: $0) }
                self.view?.performBatchUpdates({
                    self.view?.insertItems(at: indexPaths)
                }, completion: { _ in
                    self.view?.refreshControlEndRefreshing()
                })
            }, failure: { error in
                self.view?.refreshControlEndRefreshing()
                self.state = .emptyError
                self.items.append(.errorMessageFullScreen)
                self.view?.insertItems(at: [IndexPath(item: 0)])
            })
        case .emptyError:
            state = .emptyProgress
            view?.refreshControlBeginRefreshing()
            
            streamsService.getStreams(page: 1, success: { [weak self] result in
                guard let `self` = self else { return }
                
                self.page = 1
                
                let deletedIndexPaths  = (0..<self.items.count).map { IndexPath(item: $0) }
                self.items.removeAll()
                
                let newitems: [StreamsCollectionItemTypes] = result.data.map {
                    let model = StreamsCellViewModel(stream: $0)
                    return .default(model: model)
                }
                self.items.append(contentsOf: newitems)
                
                if result.numberOfPages == self.page {
                    self.state = .end
                } else {
                    self.state = .data
                    self.items.append(.activityIndicator)
                }
                
                let insertedIndexPaths = (0..<self.items.count).map { return IndexPath(item: $0) }
                self.view?.performBatchUpdates({
                    self.view?.deleteItems(at: deletedIndexPaths)
                    self.view?.insertItems(at: insertedIndexPaths)
                }, completion: { _ in
                    self.view?.refreshControlEndRefreshing()
                })
            }, failure: { error in
                self.view?.refreshControlEndRefreshing()
                self.state = .emptyError
            })
        case .emptyProgress, .refresh:
            break
        case .data, .end, .pageProgress:
            state = .refresh
            streamsService.getStreams(page: page, success: { [weak self] result in
                guard let `self` = self else { return }
                
                self.page = 1

                let newitems: [StreamsCollectionItemTypes] = result.data.map {
                    let model = StreamsCellViewModel(stream: $0)
                    return .default(model: model)
                }
                let deletedIndexPaths  = (0..<self.items.count).map { IndexPath(item: $0) }
                self.items.removeAll()
                
                self.items.append(contentsOf: newitems)
                
                if result.numberOfPages == self.page {
                    self.state = .end
                } else {
                    self.state = .data
                    self.items.append(.activityIndicator)
                }
                
                let insertedIndexPaths = (0..<self.items.count).map { IndexPath(item: $0) }
  
                self.view?.performBatchUpdates({
                    self.view?.deleteItems(at: deletedIndexPaths)
                    self.view?.insertItems(at: insertedIndexPaths)
                }, completion: { _ in
                    self.view?.refreshControlEndRefreshing()
                })
            }, failure: { error in
                self.state = .data
                self.view?.refreshControlEndRefreshing()
            })
        }
    }
    
    func loadNextPage() {
        switch state {
        case .empty, .emptyProgress, .emptyError, .emptyData, .pageProgress, .refresh, .end:
            break
        case .data:
            state = .pageProgress
            streamsService.getStreams(page: page + 1, success: { [weak self] result in
                guard let `self` = self else { return }
                guard result.page == self.page + 1 else { return }
                
                self.page = result.page
                
                let newitems: [StreamsCollectionItemTypes] = result.data.map {
                    let model = StreamsCellViewModel(stream: $0)
                    return .default(model: model)
                }
                
                let deletedIndexPaths  = [IndexPath(item: self.items.count - 1)]
                self.items.removeLast()
                
                var insertedIndexPaths = (self.items.count..<self.items.count + newitems.count).map { IndexPath(item: $0) }
                self.items.append(contentsOf: newitems)
                
                if result.numberOfPages == self.page {
                    self.state = .end
                } else {
                    self.state = .data
                    self.items.append(.activityIndicator)
                    insertedIndexPaths.append(IndexPath(item: self.items.count - 1))
                }
                
                self.view?.performBatchUpdates({
                    self.view?.deleteItems(at: deletedIndexPaths)
                    self.view?.insertItems(at: insertedIndexPaths)
                }, completion: nil)
            }, failure: { error in
                self.state = .data
            })
        }
    }
    
}

extension StreamsPresenter: MVPCollectionViewDataSource {
 
    typealias ViewModelType = StreamsCollectionItemTypes
    
    func numberOfItems(in section: Int) -> Int {
        return items.count
    }
    
    func itemForCell(at indexPath: IndexPath) -> StreamsCollectionItemTypes {
        return items[indexPath.row]
    }
    
}
