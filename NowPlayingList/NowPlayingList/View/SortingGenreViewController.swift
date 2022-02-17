//
//  GenrePageViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

import UIKit

class SortingGenreViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let test = UILabel()
        view.backgroundColor = .black // 배경색
        view.addSubview(test)
        test.text = "GenrePageViewController" // test를 위해서 출력할 라벨
        test.textColor = .white
        test.translatesAutoresizingMaskIntoConstraints = false
        test.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        test.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
