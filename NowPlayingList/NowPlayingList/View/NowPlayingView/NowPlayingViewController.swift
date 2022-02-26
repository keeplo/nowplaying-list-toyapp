//
//  MainListViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/15.
//

import UIKit

class NowPlayingViewController: UIViewController {
    var viewDataSource: NowPlayingViewDataSource?
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
        collectionView.register(NowPlayingViewCell.classForCoder(),
                                      forCellWithReuseIdentifier: NowPlayingViewCell.className)
        viewDataSource = NowPlayingViewDataSource(
            networkManager: NowPlayingListNetworkManager(),
            changedListCompletion: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        },
            selectedItmeCompletion: { seletedMovie in
            if let detailVC = MovieDetailViewController.updateModel(by: seletedMovie) {
                self.navigationController?.pushViewController(detailVC, animated: false)
            } else {
                NSLog("\(#function) - MovieDetailViewController 인스턴스 생성실패")
            }
        })
        collectionView.dataSource = viewDataSource
        collectionView.delegate = viewDataSource
        
        self.navigationController?.navigationBar.topItem?.title = "현재 상영 중"
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDataSource?.loadNowPlayingList()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

