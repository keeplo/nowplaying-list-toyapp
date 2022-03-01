//
//  CanShowMovieDetailView.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/26.
//

import UIKit.UINavigationController

protocol CanShowMovieDetailView {
    var navigationController: UINavigationController? { get }
    func showDetailView(with movie: Movie)
}

extension CanShowMovieDetailView {
    func showDetailView(with movie: Movie) {
        if let detailVC = MovieDetailViewController.updateModel(by: movie) {
            self.navigationController?.pushViewController(detailVC, animated: false)
        } else {
            NSLog("\(#function) - MovieDetailViewController 인스턴스 생성실패")
        }
    }
}
