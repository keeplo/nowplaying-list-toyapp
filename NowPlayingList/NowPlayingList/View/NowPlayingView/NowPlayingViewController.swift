//
//  MainListViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/15.
//

import UIKit
import SnapKit

final class NowPlayingViewController: UIViewController, CanShowMovieDetailView {
    var navigation: UINavigationController?
    private var viewModel: NowPlayingViewModelImpl?
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        collectionView.register(NowPlayingViewCell.classForCoder(),
                                forCellWithReuseIdentifier: NowPlayingViewCell.className)
        viewModel = NowPlayingViewModelImpl(
            changedListCompletion: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        },
            selectedItmeCompletion: { seletedMovie in
                self.showDetailView(with: seletedMovie)
        })
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        
        navigation = self.navigationController
        navigation?.navigationBar.topItem?.title = Strings.Navigation.nowplaying.description
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
        viewModel?.fetchNowPlayingList()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

