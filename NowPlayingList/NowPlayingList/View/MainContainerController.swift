//
//  MainViewController.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/06/17.
//

import UIKit

final class MainContainerController: UITabBarController {
    
    struct Dependecy {
        let coordinator: SceneCoordinator
        let tabViewControllers: [UINavigationController]
    }
    
    private let dependency: Dependecy
    
    init(dependency: Dependecy) {
        self.dependency = dependency
            
        super.init(nibName: nil, bundle: nil)
        self.setupAttributes()
        self.setupViewControllers()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttributes() {
        self.hidesBottomBarWhenPushed = true
        
        self.tabBar.do {
            $0.barStyle = .default
            $0.isTranslucent = false
            $0.backgroundColor = .systemGroupedBackground
        }
        self.view.do {
            $0.backgroundColor = .systemBackground
        }
    }
    
    private func setupViewControllers() {
        let viewControllers = dependency.tabViewControllers
        
        self.setViewControllers(viewControllers, animated: false)
    }
    
}
