//
//  SearchView.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/03/17.
//

import Foundation

import UIKit

protocol SearchViewDelegate: UITableViewDelegate, UISearchBarDelegate {
    
}
typealias SearchViewDataSource = UITableViewDataSource

final class SearchView: UIView {
    
    weak var delegate: SearchViewDelegate? {
        didSet {
            self.tableView.delegate = self.delegate
            self.searchBar.delegate = self.delegate
        }
    }
    
    weak var dataSource: SearchViewDataSource? {
        didSet { self.tableView.dataSource = self.dataSource }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupLayout()
        self.setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.searchBar.do {
            $0.placeholder = Strings.SearchBar.placeholder.description
        }
        
        self.tableView.do {
            $0.register(SearchedListCell.self)
        }
    }
    
    private let searchBar = UISearchBar(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .plain)
}

extension SearchView {
    func reloadData() {
        self.tableView.reloadData()
    }
}
