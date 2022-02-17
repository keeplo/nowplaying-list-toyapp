//
//  SearchPageVIewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/16.
//

import UIKit

class SearchingMovieVIewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let test = UILabel()
        view.backgroundColor = .black // 배경색
        view.addSubview(test)
        test.text = "SearchPageVIewController" // test를 위해서 출력할 라벨
        test.textColor = .white
        test.translatesAutoresizingMaskIntoConstraints = false
        test.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        test.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
