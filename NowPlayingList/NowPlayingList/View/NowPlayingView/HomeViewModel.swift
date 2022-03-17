//
//  HomeViewModel.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

import Foundation

protocol HomeViewModelType {
    associatedtype Item
    func numberOfItemsInSection(_ section: Int) -> Int
    func cellModel(at indexPath: IndexPath) -> Item?
    func didSelectedItemAt(_ indexPath: IndexPath) -> Movie?
    func willDisplay(forItemAt: IndexPath)
    
    func fetchNowPlayingList()
}

final class HomeViewModel: NSObject, DecodeRequestable {
    
    enum Item {
        case cell(NowPlayingListCellModel)
    }
    
    weak var delegate: HomeViewModelEvent?
    private var page: (last: Int, total: Int) = (1, 0)
    private var movies: [Movie] = [] {
        didSet {
            self.delegate?.reloadData()
        }
    }
}

extension HomeViewModel: HomeViewModelType{
    // MARK: - DataSource
    func numberOfItemsInSection(_ section: Int) -> Int {
        return self.movies.count
    }
    
    func cellModel(at indexPath: IndexPath) -> Item? {
        guard let movie = self.movies[safe: indexPath.item] else { return nil }
        return .cell(NowPlayingListCellModel(title: movie.title,
                                             rated: movie.rated,
                                             imagePath: movie.posterPath))
    }
    
    // MARK: - Delegate
    func didSelectedItemAt(_ indexPath: IndexPath) -> Movie? {
        guard let movie = self.movies[safe: indexPath.row] else { return nil }
        return movie
    }
    
    func willDisplay(forItemAt indexPath: IndexPath) {
        if page.last < page.total, indexPath.item == (self.movies.count / 4) {
            page.last += 1
            self.fetchNowPlayingList()
        }
    }
    
    func fetchNowPlayingList() {
        guard let url = NowPlayingListAPI.nowplaying(page.last).makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        parseRequestedData(url: url, type: Page.self) { page in
            self.movies.append(contentsOf: page.results)
            self.page = (page.page, page.totalPages)
        }
    }
}
