//
//  MainListViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/15.
//

import UIKit

final class NowPlayingViewController: UIViewController, CanShowMovieDetailView {
    var navigation: UINavigationController?
    private var viewDataSource: NowPlayingViewDataSource?
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
        collectionView.register(NowPlayingViewCell.classForCoder(),
                                      forCellWithReuseIdentifier: NowPlayingViewCell.className)
        viewDataSource = NowPlayingViewDataSource(
            changedListCompletion: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        },
            selectedItmeCompletion: { seletedMovie in
                self.showDetailView(with: seletedMovie)
        })
        collectionView.dataSource = viewDataSource
        collectionView.delegate = viewDataSource
        
        navigation = self.navigationController
        navigation?.navigationBar.topItem?.title = "현재 상영 중"
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDataSource?.loadNowPlayingList()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

