//
//  SearchingMovieViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit

final class SearchingMovieVIewController: UIViewController, CanShowMovieDetailView {
    var navigation: UINavigationController?
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
            changedListCompletion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            },
            selectedItmeCompletion: { seletedMovie in
                self.showDetailView(with: seletedMovie)
            })
        searchBar.delegate = tableViewDataSource
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDataSource
        
        navigation = self.navigationController
        navigation?.navigationBar.topItem?.title = "검색"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
    
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
