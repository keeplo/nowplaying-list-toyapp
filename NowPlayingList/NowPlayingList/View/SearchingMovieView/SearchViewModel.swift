//
//  SearchViewModel.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import Foundation

protocol SearchViewModelType {
    associatedtype Item
    func requestSearchMovie(of text: String)
    func resetDataSource()
    
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellModel(at indexPath: IndexPath) -> Item?
    func willDisplay(forRowAt indexPath: IndexPath)
    func didSelectRowAt(at indexPath: IndexPath) -> Movie
    
    func cellHeightType() -> SearchViewModel.SearchResult
}

final class SearchViewModel: NSObject, DecodeRequestable {
    
    enum Item {
        case emptyCell
        case cell(SearchedListCellModel)
    }
    
    enum SearchResult {
        case emptyResult
        case success
    }
    
    weak var delegate: SearchViewModelEvent?
    private var page: (last: Int, total: Int) = (1, 0)
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
        if !text.isEmpty { currentSearchWord = text }
        print(#function)
        guard let url = NowPlayingListAPI.searching(text, page.last).makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        parseRequestedData(url: url, type: Page.self) { page in
            if page.results.isEmpty {
                print("empty")
                self.searchResult = .emptyResult
                self.movies = []
            } else {
                print(page.results.count)
                self.searchResult = .success
                self.movies.append(contentsOf: page.results)
                self.page = (page.page, page.totalPages)
            }
        }
    }
    
    func resetDataSource() {
        searchResult = .success
        movies = []
        page = (1, 0)
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
            let movie = self.movies[indexPath.row]
            return .cell(SearchedListCellModel(title: movie.title,
                                               date: movie.releaseDate, rated: movie.rated,
                                               imagePath: movie.posterPath))
        }
    }
    
    func willDisplay(forRowAt indexPath: IndexPath) {
        if page.last < page.total, indexPath.item == (movies.count / 2) {
            page.last += 1
            self.requestSearchMovie()
        }
    }
    
    func didSelectRowAt(at indexPath: IndexPath) -> Movie {
        return self.movies[indexPath.row]
    }
    
    func cellHeightType() -> SearchResult {
        return self.searchResult
    }
}


