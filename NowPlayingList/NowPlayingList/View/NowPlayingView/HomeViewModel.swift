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
    func didSelectedItemAt(_ indexPath: IndexPath)
//    func willDisplay(forItemAt: IndexPath)
    
    func fetchList()
}

final class HomeViewModel: NSObject {
    
    struct Dependency {
        let coordinator: SceneCoordinator
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Item {
        case cell(NowPlayingListCellModel)
    }
    
    weak var delegate: HomeViewModelEvent?
    private var page = Page.base
    private var movies: [Movie] = [] {
        didSet {
            self.delegate?.reloadData()
        }
    }
}

extension HomeViewModel: HomeViewModelType {
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
    func didSelectedItemAt(_ indexPath: IndexPath) {
        guard let movie = self.movies[safe: indexPath.row] else { return }
        dependency.coordinator.push(at: .home,
                                    scene: .movie(.init(dependency: .init(movie: movie))),
                                    animated: true)
    }
    
//    func willDisplay(forItemAt indexPath: IndexPath) {
//        if page.page < page.totalPages, indexPath.item == (self.movies.count / 4) {
//            page.page += 1
//            self.fetchList()
//        }
//    }
//    
    func fetchList() {
        API
            .fetch(page: page.page)
            .request(completion: { [weak self] result in
                switch result {
                case .success(let page):
                    self?.page = page
                    self?.movies.append(contentsOf: page.results)
                case .failure(let error):
                    debugPrint("\(#function) - local: \(error), description: \(error.localizedDescription)")
                }
            })
    }
    
    func fetchMoreList() {
        guard page.page < page.totalPages else {
            return
        }
        fetchList()
    }
    
}
