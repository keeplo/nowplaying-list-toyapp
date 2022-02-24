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
        configuraeCollectionView()
        collectionView.register(NowPlayingViewCell.classForCoder(),
                                      forCellWithReuseIdentifier: NowPlayingViewCell.className)
        viewDataSource = NowPlayingViewDataSource(networkManager: NowPlayingListNetworkManager()) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                print("reload")
            }
        }
        collectionView.dataSource = viewDataSource
        collectionView.delegate = self
        
        self.navigationItem.title = "현재 상영 중"
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDataSource?.loadNowPlayingList()
    }
    
    func configuraeCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension NowPlayingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemPerRow: CGFloat = 2
        let itemRate:CGFloat = 2/3
        let padding: CGFloat = 20
        
        let cellWidth = (width - padding) / itemPerRow
        let cellHeight = (cellWidth / itemRate) + padding + padding
                
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

