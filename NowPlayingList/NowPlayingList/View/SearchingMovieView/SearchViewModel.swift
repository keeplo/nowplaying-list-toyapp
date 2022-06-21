//
//  SearchViewModel.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import Foundation

protocol SearchViewModelType {
    associatedtype Item

    func numberOfRowsInSection(_ section: Int) -> Int
    func cellModel(at indexPath: IndexPath) -> Item?
//    func willDisplay(forRowAt indexPath: IndexPath)
    func didSelectRowAt(_ indexPath: IndexPath)
    func cellHeightType() -> SearchViewModel.SearchResult
    
    func requestSearchMovie(of text: String)
    func resetDataSource()
}

final class SearchViewModel: NSObject {
    
    struct Dependency {
        let coordinator: SceneCoordinator
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Item {
        case emptyCell
        case cell(SearchedListCellModel)
    }
    
    enum SearchResult {
        case emptyResult
        case success
    }
    
    weak var delegate: SearchViewModelEvent?
    private var page = Page.base
    private var currentSearchWord: String = Strings.emptyString
    private var searchResult: SearchResult = .success
    private var movies: [Movie] = [] {
        didSet {
            self.delegate?.reloadData()
        }
    }
    
}

extension SearchViewModel: SearchViewModelType {
    
    func requestSearchMovie(of text: String = Strings.emptyString) {
        if !text.isEmpty { self.currentSearchWord = text }
        API
            .search(by: text, page: page.page)
            .request { [weak self] result in
                switch result {
                case .success(let page):
                    if page.results.isEmpty {
                        self?.page = .base
                        self?.movies = []
                    } else {
                        self?.searchResult = .success
                        self?.movies.append(contentsOf: page.results)
                        self?.page = page
                    }
                case .failure(let error):
                    debugPrint("\(#function) - \(error.localizedDescription)")
                }
            }
    }
    
    func resetDataSource() {
        searchResult = .success
        movies = []
        page = .base
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        switch searchResult {
        case .emptyResult:
            return 1
        case .success:
            return movies.count
        }
    }
    
    func cellModel(at indexPath: IndexPath) -> Item? {
        switch searchResult {
        case .emptyResult:
            return .emptyCell
        case .success:
            guard let movie = self.movies[safe: indexPath.row] else { return nil }
            return .cell(SearchedListCellModel(title: movie.title,
                                               date: movie.releaseDate, rated: movie.rated,
                                               imagePath: movie.posterPath))
        }
    }
    
//    func willDisplay(forRowAt indexPath: IndexPath) {
//        if page.last < page.total, indexPath.item == (movies.count / 2) {
//            page.last += 1
//            self.requestSearchMovie()
//        }
//    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        guard let movie = self.movies[safe: indexPath.row] else { return }
        
        dependency.coordinator.push(at: .search,
                                    scene: .movie(.init(dependency: .init(movie: movie))),
                                    animated: true)
    }
    
    func cellHeightType() -> SearchResult {
        return self.searchResult
    }
    
}


