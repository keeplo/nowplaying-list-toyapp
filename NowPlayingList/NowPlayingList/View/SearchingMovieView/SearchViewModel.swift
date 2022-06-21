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
    func willDisplay(forRowAt indexPath: IndexPath)
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
        case idle
        case success(String)
        case emptyResult
    }
    
    weak var delegate: SearchViewModelEvent?
    private var page: Page = .base
    private var searchResult: SearchResult = .idle
    private var currentSearchWord: String = Strings.emptyString
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
            .search(by: text, page: page.page + 1)
            .request { [weak self] result in
                switch result {
                case .success(let page):
                    if page.results.isEmpty {
                        self?.page = .base
                        self?.movies = []
                    } else {
                        self?.searchResult = .success(text)
                        self?.movies.append(contentsOf: page.results)
                        self?.page = page
                    }
                case .failure(let error):
                    debugPrint("\(#function) - \(error.localizedDescription)")
                }
            }
    }
    
    func requestMoreSearchedMovie() {
        guard case let SearchResult.success(keyword) = searchResult else { return }
        
        API
            .search(by: keyword, page: page.page + 1)
            .request { [weak self] result in
                switch result {
                case .success(let page):
                    self?.movies.append(contentsOf: page.results)
                    self?.page = page
                case .failure(let error):
                    debugPrint("\(#function) - \(error.localizedDescription)")
                }
            }
    }
    
    func resetDataSource() {
        page = .base
        searchResult = .idle
        movies = []
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        switch searchResult {
        case .success:
            return movies.count
        default:
            return 1
        }
    }
    
    func cellModel(at indexPath: IndexPath) -> Item? {
        switch searchResult {
        case .success:
            guard let movie = self.movies[safe: indexPath.row] else { return nil }
            return .cell(SearchedListCellModel(title: movie.title,
                                               date: movie.releaseDate, rated: movie.rated,
                                               imagePath: movie.posterPath))
        default:
            return .emptyCell
        }
    }
    
    func willDisplay(forRowAt indexPath: IndexPath) {
        if page.page < page.totalPages, indexPath.item == (movies.count / 2) {
            self.requestSearchMovie()
        }
    }
    
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


