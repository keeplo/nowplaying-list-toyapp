//
//  DetailViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit
import Then
import SnapKit

protocol CanShowMovieDetailView {
    var navigationController: UINavigationController? { get }
    func showDetailView(with movie: Movie)
}

extension CanShowMovieDetailView {
    func showDetailView(with movie: Movie) {
        if let detailVC = DetailViewController.updateModel(by: movie) {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(detailVC, animated: false)
        } else {
            NSLog("\(#function) - MovieDetailViewController 인스턴스 생성실패")
        }
    }
}

final class DetailViewController: UIViewController {
    
    static func updateModel(by movie: Movie) -> DetailViewController? {
        let vcInstance = DetailViewController().then {
            $0.hidesBottomBarWhenPushed = true
        }
        vcInstance.seletedMovie = movie
        return vcInstance
    }
    
    private var seletedMovie: Movie?
    private let dummyGuideLabel = UILabel(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.setupAttributes()
    }
    
    private func setupLayout() {
        self.view.addSubview(self.dummyGuideLabel)
        self.dummyGuideLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        self.view.do {
            $0.backgroundColor = .systemBackground
        }
        
        self.dummyGuideLabel.do {
            $0.text = seletedMovie?.title ?? self.className
            $0.textColor = .label
        }
    }
}
