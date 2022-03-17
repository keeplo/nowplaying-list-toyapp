//
//  MainViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/15.
//

import UIKit

final class MainViewController: UITabBarController {
    
    private var nowplayingViewController: UINavigationController = {
        let viewController = NowPlayingViewController().then {
            $0.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "1.circle.fill"), selectedImage: nil)
        }
        return UINavigationController(rootViewController: viewController)
    }()
    
    private var searchingMovieViewController: UINavigationController = {
        let viewController = SearchingMovieVIewController().then {
            $0.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "2.circle.fill"), selectedImage: nil)
        }
        return UINavigationController(rootViewController: viewController)
    }()
    
    private var sortingGenreViewController: UINavigationController = {
        let viewController = SortingGenreViewController().then {
            $0.tabBarItem = UITabBarItem(title: "장르", image: UIImage(systemName: "3.circle.fill"), selectedImage: nil)
        }
        return UINavigationController(rootViewController: viewController)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBar()
        self.setupViewControllers()
    }
    
    private func setupTabBar() {
        self.tabBar.do {
            $0.barStyle = .default
            $0.isTranslucent = false
        }
    }
    
    private func setupViewControllers() {
        let viewControllers = [
            self.nowplayingViewController,
            self.searchingMovieViewController,
            self.sortingGenreViewController
        ]
        
        self.setViewControllers(viewControllers, animated: false)
    }
}
