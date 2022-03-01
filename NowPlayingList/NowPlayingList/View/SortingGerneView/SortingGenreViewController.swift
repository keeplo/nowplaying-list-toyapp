//
//  SortingGenreViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/25.
//

import UIKit

final class SortingGenreViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let test = UILabel()
        view.addSubview(test)
        test.text = SortingGenreViewController.className
        test.textColor = .label
        test.translatesAutoresizingMaskIntoConstraints = false
        test.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        test.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
    }
}
