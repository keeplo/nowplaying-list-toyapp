//
//  SearchingMovieViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit

class SearchingMovieVIewController: UIViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    private var tableViewDataSource: SearchedListViewDataSource?
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSearchBar()
        configureTableView()
        tableView.register(SearchedListViewCell.classForCoder(),
                           forCellReuseIdentifier: SearchedListViewCell.className)
        tableViewDataSource = SearchedListViewDataSource(
            networkManager: SearchingMovieNetworkManager(),
            changedListCompletion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            },
            selectedItmeCompletion: { seletedMovie in
                if let detailVC = MovieDetailViewController.updateModel(by: seletedMovie) {
                    self.navigationController?.pushViewController(detailVC, animated: false)
                } else {
                    NSLog("\(#function) - MovieDetailViewController 인스턴스 생성실패")
                }
            })
        searchBar.delegate = self
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDataSource
        
        self.navigationController?.navigationBar.topItem?.title = "검색"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
    
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension SearchingMovieVIewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableViewDataSource?.resetDataSource()
        guard let inputText = searchBar.text,
              !inputText.isEmpty else {
            NSLog("\(#function) - 입력된 문자가 없음")
            return
        }
        tableViewDataSource?.requestSearchMovie(of: inputText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let inputText = searchBar.text,
           inputText.isEmpty {
            tableViewDataSource?.resetDataSource()
        }
    }
}
