//
//  HomeViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/15.
//

import UIKit
import Then
import SnapKit

protocol HomeViewModelEvent: AnyObject {
    func reloadData()
}

final class HomeViewController: UIViewController, CanShowMovieDetailView {
    private let homeView = HomeView(frame: .zero)
    private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
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
        
        self.navigationController?.navigationBar.topItem?.title = Strings.Navigation.nowplaying.description
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchNowPlayingList()
    }
    
    private func setupLayout() {
        self.view.addSubview(self.homeView)
        self.homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.homeView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        
        self.viewModel.do {
            $0.delegate = self
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let itemPerRow: CGFloat = 2
        let itemRate:CGFloat = 2/3
        let padding: CGFloat = 20
        
        let cellWidth = (width - padding * 2) / itemPerRow
        let cellHeight = (cellWidth / itemRate) + padding + padding
                
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension HomeViewController: HomeViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel.willDisplay(forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seletedMovie = self.viewModel.didSelectedItemAt(indexPath)
        self.showDetailView(with: seletedMovie)
    }
}

extension HomeViewController: HomeViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = self.viewModel.cellModel(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        switch model {
        case .cell(let nowPlayingListCellModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingListCell.className, for: indexPath) as? NowPlayingListCell else {
                return UICollectionViewCell()
            }
            cell.configureData(nowPlayingListCellModel)
            return cell
        }
    }
}

extension HomeViewController: HomeViewModelEvent {
    func reloadData() {
        self.homeView.reloadData()
    }
}
