//
//  SearchingMovieViewModelImpl.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit

protocol SearchMovieViewModel {
    func requestSearchMovie(of text: String)
    func resetDataSource()
}

final class SearchingMovieViewModelImpl: NSObject, DecodeRequestable {
    typealias ChangedListCompletion = () -> Void
    typealias SelectedItmeCompletion = (Movie) -> Void
    
    enum SearchResult {
        case emptyResult
        case success
    }
    
    private var changedListCompletion: ChangedListCompletion?
    private var selectedItmeCompletion: SelectedItmeCompletion?
    
    private var autoSearchTimer: Timer?
    private var page: (last: Int, total: Int) = (1, 0)
    private var currentSearchWord: String = ""
    private var searchResult: SearchResult = .success
    private var movies: [Movie] = [] {
        didSet {
            changedListCompletion?()
        }
    }
    
    init(changedListCompletion: @escaping ChangedListCompletion,
         selectedItmeCompletion: @escaping SelectedItmeCompletion) {
        self.changedListCompletion = changedListCompletion
        self.selectedItmeCompletion = selectedItmeCompletion
    }
}

extension SearchingMovieViewModelImpl: SearchMovieViewModel {
    func requestSearchMovie(of text: String = "") {
        if !text.isEmpty { currentSearchWord = text }
        guard let url = NowPlayingListAPI.searching(text, page.last).makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        parseRequestedData(url: url, type: Page.self) { page in
            if page.results.isEmpty {
                self.searchResult = .emptyResult
                self.movies = []
            } else {
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
}

extension SearchingMovieViewModelImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchResult {
        case .emptyResult:
            return 1
        case .success:
            return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchResult {
        case .emptyResult:
            return makeEmptyResultCell()
        case .success:
            guard let cell = makeSearchedListCell(tableView: tableView, at: indexPath) else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    private func makeEmptyResultCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let noticeLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "검색 결과가 없습니다"
            label.font = .preferredFont(forTextStyle: .title1)
            label.textColor = .gray
            return label
        }()
        cell.addSubview(noticeLabel)
        noticeLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        noticeLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        return cell
    }
    
    private func makeSearchedListCell(tableView: UITableView, at indexPath: IndexPath) -> SearchedListViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedListViewCell.className,
                                                       for: indexPath) as? SearchedListViewCell else {
            return nil
        }
        let movie = movies[indexPath.row]
        cell.configureData(title: movie.title, date: movie.releaseDate, rated: movie.rated)
    
        guard let posterPath = movie.posterPath else { return cell }
        let nsPath = NSString(string: posterPath)
        if let cachedImage = ImageCacheManager.shared.object(forKey: nsPath) {
            cell.configureImage(cachedImage)
        } else {
            guard let imageURL = NowPlayingListAPI.makeImageURL(posterPath) else {
                NSLog("\(#function) - 포스터 URL 생성 실패")
                return cell
            }
            ImageCacheManager.loadImage(url: imageURL, path: nsPath) { image in
                if indexPath == tableView.indexPath(for: cell) {
                    cell.configureImage(image)
                }
            }
        }
        return cell
    }
}

extension SearchingMovieViewModelImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if page.last < page.total, indexPath.item == (movies.count / 2) {
            page.last += 1
            requestSearchMovie()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seletedMovie = movies[indexPath.row]
        selectedItmeCompletion?(seletedMovie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height / 5
        return height
    }
}

extension SearchingMovieViewModelImpl: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let inputText = searchBar.text,
              !inputText.isEmpty else {
            NSLog("\(#function) - 입력된 문자가 없음")
            return
        }
        if autoSearchTimer != nil { cancelTimer() }
        resetDataSource()
        requestSearchMovie(of: inputText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let inputText = searchBar.text else { return }
        if inputText.isEmpty {
            resetDataSource()
            cancelTimer()
        } else {
            startTimer {
                self.requestSearchMovie(of: inputText)
            }
        }
    }
}

extension SearchingMovieViewModelImpl {
    private func startTimer(perform: @escaping () -> Void) {
        if autoSearchTimer != nil { cancelTimer() }
        autoSearchTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.resetDataSource()
            self?.cancelTimer()
            perform()
        }
    }
    
    private func cancelTimer() {
        autoSearchTimer?.invalidate()
        autoSearchTimer = nil
    }
}
