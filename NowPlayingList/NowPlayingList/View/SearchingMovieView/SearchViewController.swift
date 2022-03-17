//
//  SearchViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController, CanShowMovieDetailView {
    var navigation: UINavigationController?
    private let searchBar = UISearchBar().then {
        $0.placeholder = Strings.SearchBar.placeholder.description
    }
    private var viewModel: SearchViewModel?
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureTableView()
        tableView.register(SearchedListViewCell.self)
        viewModel = SearchViewModel(
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
        self.view.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView = UITableView()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
