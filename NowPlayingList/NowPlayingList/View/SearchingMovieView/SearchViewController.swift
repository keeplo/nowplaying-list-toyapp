//
//  SearchViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit
import Then
import SnapKit

protocol SearchViewModelEvent: AnyObject {
    func reloadData()
}

final class SearchViewController: UIViewController {
    private let navigationView = NavigationView(frame: .zero)
    private let searchBar = UISearchBar(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(SearchedListCell.self)
    }
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupLayout() {
        self.view.addSubview(self.navigationView)
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(66)
        }
        
        self.view.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.navigationView.do {
            $0.configure(title: Strings.Navigation.searching.description)
        }
        
        self.searchBar.do {
            $0.delegate = self
        }
        
        self.tableView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        
        self.viewModel.do {
            $0.delegate = self
        }
    }
}

extension SearchViewController: UITableViewDataSource {
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

extension SearchViewController: UITableViewDelegate {
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.willDisplay(forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.viewModel.cellHeightType() {
        case .emptyResult:
            return self.view.bounds.height
        case .success:
            return UIScreen.main.bounds.height / 5
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
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
        self.tableView.reloadData()
    }
    
}
