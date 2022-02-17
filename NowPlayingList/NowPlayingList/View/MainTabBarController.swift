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
        
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nowPlayingTab = NowPlayingViewController()
        let nowPlayingTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "1.circle.fill"), tag: 1)
        nowPlayingTab.tabBarItem = nowPlayingTabBarItem
        
        let searchPageTab = SearchingMovieVIewController()
        let searchPageTabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "2.circle.fill"), tag: 2)
        searchPageTab.tabBarItem = searchPageTabBarItem
        
        let genrePageTab = SortingGenreViewController()
        let genrePageTabBarItem = UITabBarItem(title: "장르", image: UIImage(systemName: "3.circle.fill"), tag: 3)
        genrePageTab.tabBarItem = genrePageTabBarItem
        
        self.viewControllers = [nowPlayingTab, searchPageTab, genrePageTab]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.className)")
    }
}
