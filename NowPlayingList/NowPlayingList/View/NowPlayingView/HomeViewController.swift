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

final class HomeViewController: UIViewController {
    
    private let navigationView = NavigationView(frame: .zero)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(NowPlayingListCell.self)
    }
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
        self.viewModel.fetchList()
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
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.navigationView.do {
            $0.configure(title: Strings.Navigation.nowplaying.description)
        }
        
        self.collectionView.do {
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
        let cellHeight = (cellWidth / itemRate) + (padding * 2)
                
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.viewModel.willDisplay(forItemAt: indexPath)
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.didSelectedItemAt(indexPath)
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
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
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}
