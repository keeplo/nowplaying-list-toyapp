//
//  SearchViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit
import SnapKit

protocol SearchViewModelEvent: AnyObject {
    func reloadData()
}

final class SearchViewController: UIViewController, CanShowMovieDetailView {
    private let searchView = SearchView(frame: .zero)
    private var viewModel: SearchViewModel
    
    private var autoSearchTimer: Timer?
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.setupAttributes()
        
        self.navigationController?.navigationBar.topItem?.title = Strings.Navigation.searching.description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        self.view.addSubview(self.searchView)
        self.searchView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setupAttributes() {
        self.searchView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        
        self.viewModel.do {
            $0.delegate = self
        }
    }
}

extension SearchViewController: SearchViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.viewModel.cellModel(at: indexPath) else {
            return UITableViewCell()
        }
        
        switch model {
        case .emptyCell:
            return makeEmptyResultCell()
        case .cell(let searchedListCellModel):
            guard let cell = tableView.dequeueReusableCell(SearchedListCell.self, at: indexPath) else {
                return UITableViewCell()
            }
            cell.configureData(searchedListCellModel)
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
}

extension SearchViewController: SearchViewDelegate {
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.willDisplay(tableView, cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = self.viewModel.didSelectRowAt(at: indexPath)
        self.showDetailView(with: selectedMovie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.cellHeight(tableView)
    }
    
    // MARK: - SearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let inputText = searchBar.text,
              !inputText.isEmpty else {
            NSLog("\(#function) - 입력된 문자가 없음")
            return
        }
        if autoSearchTimer != nil { cancelTimer() }
        self.viewModel.resetDataSource()
        self.viewModel.requestSearchMovie(of: inputText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let inputText = searchBar.text else { return }
        if inputText.isEmpty {
            self.viewModel.resetDataSource()
            cancelTimer()
        } else {
            startTimer {
                self.viewModel.requestSearchMovie(of: inputText)
            }
        }
    }
}

// MARK: -- Timer Methods
extension SearchViewController {
    private func startTimer(perform: @escaping () -> Void) {
        if autoSearchTimer != nil { cancelTimer() }
        autoSearchTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.viewModel.resetDataSource()
            self?.cancelTimer()
            perform()
        }
    }
    
    private func cancelTimer() {
        autoSearchTimer?.invalidate()
        autoSearchTimer = nil
    }
}

extension SearchViewController: SearchViewModelEvent {
    func reloadData() {
        self.searchView.reloadData()
    }
}
