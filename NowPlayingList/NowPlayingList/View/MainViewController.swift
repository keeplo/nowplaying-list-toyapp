//
//  MainViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/15.
//

import UIKit

final class MainViewController: UITabBarController {
    
    private var homeViewController: UINavigationController = {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel).then {
            $0.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "1.circle.fill"), selectedImage: nil)
        }
        return UINavigationController(rootViewController: viewController)
    }()
    
    private var searchViewController: UINavigationController = {
        let viewModel = SearchViewModel()
        let viewController = SearchViewController(viewModel: viewModel).then {
            $0.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "2.circle.fill"), selectedImage: nil)
        }
        return UINavigationController(rootViewController: viewController)
    }()
    
    private var genreViewController: UINavigationController = {
        let viewController = GenreViewController().then {
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
            $0.backgroundColor = .systemGroupedBackground
        }
    }
    
    private func setupViewControllers() {
        let viewControllers = [
            self.homeViewController,
            self.searchViewController,
            self.genreViewController
        ]
        
        self.setViewControllers(viewControllers, animated: false)
    }
    
}
