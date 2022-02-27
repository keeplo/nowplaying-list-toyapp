//
//  MovieDetailViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    private var seletedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let test = UILabel()
        view.addSubview(test)
        test.text = seletedMovie?.title ?? "x"
        test.textColor = .label
        test.translatesAutoresizingMaskIntoConstraints = false
        test.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        test.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }
    
    static func updateModel(by movie: Movie) -> MovieDetailViewController? {
        let vcInstance = MovieDetailViewController()
        vcInstance.seletedMovie = movie
        return vcInstance
    }
}
