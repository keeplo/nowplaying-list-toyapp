//
//  MainTabBarController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/15.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nowPlayingVC = NowPlayingViewController()
        let nowPlayingTab = UINavigationController(rootViewController: nowPlayingVC)
        let nowPlayingTabBarItem = UITabBarItem(title: "홈",
                                                image: UIImage(systemName: "1.circle.fill"), tag: 1)
        nowPlayingTab.tabBarItem = nowPlayingTabBarItem
        
        let searchingVC = SearchingMovieVIewController()
        let searchingTab = UINavigationController(rootViewController: searchingVC)
        let searchingTabBarItem = UITabBarItem(title: "검색",
                                               image: UIImage(systemName: "2.circle.fill"), tag: 2)
        searchingTab.tabBarItem = searchingTabBarItem
        
        let sortingVC = SortingGenreViewController()
        let sortingTab = UINavigationController(rootViewController: sortingVC)
        let sortingTabBarItem = UITabBarItem(title: "장르",
                                             image: UIImage(systemName: "3.circle.fill"), tag: 3)
        sortingTab.tabBarItem = sortingTabBarItem
        
        self.viewControllers = [nowPlayingTab, searchingTab, sortingTab]
    }
}
