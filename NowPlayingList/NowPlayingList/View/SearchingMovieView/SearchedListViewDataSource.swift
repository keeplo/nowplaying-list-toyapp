//
//  SearchedListViewDataSource.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit

protocol SearchMovieViewModel {
    func requestSearchMovie(of text: String)
    func resetDataSource()
}

class SearchedListViewDataSource: NSObject, DecodeRequestable {
    typealias ChangedListCompletion = () -> Void
    typealias SelectedItmeCompletion = (Movie) -> Void
    
    private var changedListCompletion: ChangedListCompletion?
    private var selectedItmeCompletion: SelectedItmeCompletion?
    
    private var lastPage: Int = 1
    private var totalPage: Int = 0
    private var currentSearchWord: String = ""
    private var searchResult: SearchResult = .success
    private var movies: [Movie] = [] {
        didSet {
            changedListCompletion?()
        }
    }
    
    enum SearchResult {
        case emptyResult
        case success
    }
    
    init(changedListCompletion: @escaping ChangedListCompletion,
         selectedItmeCompletion: @escaping SelectedItmeCompletion) {
        self.changedListCompletion = changedListCompletion
        self.selectedItmeCompletion = selectedItmeCompletion
    }
}

extension SearchedListViewDataSource: SearchMovieViewModel {
    func requestSearchMovie(of text: String = "") {
        if !text.isEmpty { currentSearchWord = text }
        guard let url = NowPlayingListAPI.searching(text, lastPage).makeURL() else {
            NSLog("\(#function) - URL 생성 실패")
            return
        }
        loadNowPlayingList(url: url, type: Page.self) { page in
            if page.results.isEmpty {
                self.searchResult = .emptyResult
                self.movies = []
            } else {
                self.searchResult = .success
                self.movies.append(contentsOf: page.results)
                self.lastPage = page.page
                self.totalPage = page.totalPages
            }
        }
    }
    
    func resetDataSource() {
        searchResult = .success
        movies = []
        lastPage = 1
        totalPage = 0
    }
}

extension SearchedListViewDataSource: UITableViewDataSource {
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
        guard let posterPath = movie.posterPath else {
            return cell
        }
        let nsPath = NSString(string: posterPath)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: nsPath) {
            cell.configureImage(cachedImage)
        } else {
            DispatchQueue.global().async {
                guard let imageURL = NowPlayingListAPI.makeImageURL(posterPath) else {
                    NSLog("\(#function) - 포스터 URL 생성 실패")
                    return
                }
                if let imageData = NSData(contentsOf: imageURL),
                    let image = UIImage(data: Data(imageData)) {
                    ImageCacheManager.shared.setObject(image, forKey: nsPath)
                    DispatchQueue.main.async {
                        if indexPath == tableView.indexPath(for: cell) {
                            cell.configureImage(image)
                        }
                    }
                }
            }
        }
        return cell
    }
}

extension SearchedListViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if lastPage < totalPage, indexPath.item == (movies.count / 2) {
            lastPage += 1
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
