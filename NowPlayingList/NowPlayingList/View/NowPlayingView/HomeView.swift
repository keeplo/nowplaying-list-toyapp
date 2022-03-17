//
//  HomeView.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/03/17.
//

import UIKit

typealias HomeViewDelegate = UICollectionViewDelegate
typealias HomeViewDataSource = UICollectionViewDataSource

final class HomeView: UIView {
    
    weak var delegate: HomeViewDelegate? {
        didSet { self.collectionView.delegate = self.delegate }
    }
    
    weak var dataSource: HomeViewDataSource? {
        didSet { self.collectionView.dataSource = self.dataSource }
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
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.collectionView.do {
            $0.register(NowPlayingListCell.self)
        }
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
}

extension HomeView {
    func reloadData() {
        self.collectionView.reloadData()
    }
}
