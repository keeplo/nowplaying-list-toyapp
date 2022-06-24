//
//  HomeViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/15.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let navigationView = NavigationView(frame: .zero)
    private var viewModel: HomeViewModel
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
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
        self.setupBind()
        self.viewModel.fetchList()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupLayout() {
        self.view.addSubview(navigationView)
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(66)
        }
        
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.navigationView.do {
            $0.configure(title: Strings.Navigation.nowplaying.description)
        }
        
        self.collectionView.do {
            $0.register(NowPlayingListCell.self)
        }
    }
    
    private func setupBind() {
        self.collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        self.collectionView.rx.modelSelected(Movie.self)
            .subscribe { [weak self] movie in
                self?.viewModel.pushDetailView(by: movie)
            }
            .disposed(by: disposeBag)
        
        self.collectionView.rx.prefetchItems
            .compactMap(\.last?.item)
            .withUnretained(collectionView)
            .bind { [weak self] list, item in
                guard item == list.numberOfItems(inSection: 0) - 1 else { return }
                self?.viewModel.fetchList()
            }
            .disposed(by: disposeBag)
        
        // Output
        self.viewModel.output.list
            .bind(to: collectionView.rx.items) { collectionView, item, element in
                let indexPath = IndexPath(item: item, section: 0)
                let cell = collectionView.dequeueReusableCell(NowPlayingListCell.self, at: indexPath)
                cell?.configureData(.init(title: element.title, rated: element.rated, imagePath: element.posterPath))
                return cell ?? UICollectionViewCell()
            }
            .disposed(by: disposeBag)
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
