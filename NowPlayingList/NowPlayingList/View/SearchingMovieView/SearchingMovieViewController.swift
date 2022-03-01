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
        searchBar.placeholder = Strings.SearchBar.placeholder.description
        return searchBar
    }()
    private var viewModel: SearchingMovieViewModelImpl?
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureTableView()
        tableView.register(SearchedListViewCell.classForCoder(),
                           forCellReuseIdentifier: SearchedListViewCell.className)
        viewModel = SearchingMovieViewModelImpl(
            changedListCompletion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            },
            selectedItmeCompletion: { seletedMovie in
                self.showDetailView(with: seletedMovie)
            })
        searchBar.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
        navigation = self.navigationController
        navigation?.navigationBar.topItem?.title = Strings.Navigation.searching.description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
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
