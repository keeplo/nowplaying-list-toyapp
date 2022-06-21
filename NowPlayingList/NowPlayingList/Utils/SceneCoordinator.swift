//
//  SceneCoordinator.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/06/17.
//

import Foundation
import UIKit

final class SceneCoordinator {
    
    enum Scene {
        case home(HomeViewModel)
        case search(SearchViewModel)
        case sort(GenreViewModel)
        case movie(DetailViewModel)
    }
    
    enum Navigation: Int, CaseIterable {
        case home = 0
        case search
        case sort
    }
    
    private let window: UIWindow
    private var navigationControllers: [UINavigationController] = []
    
    struct Dependency {
        let window: UIWindow
    }
    
    init(_ dependency: Dependency) {
        self.window = dependency.window
    }
    
}

extension SceneCoordinator {
    
    private func makeScene(scene: Scene) -> UIViewController {
        switch scene {
        case .home(let viewModel):
            return HomeViewController(viewModel: viewModel)
        case .search(let viewModel):
            return SearchViewController(viewModel: viewModel)
        case .sort(let viewModel):
            return GenreViewController(viewModel: viewModel)
        case .movie(let viewModel):
            return DetailViewController(viewModel: viewModel)
        }
    }
    
    func root() {
        navigationControllers = [
            UINavigationController(rootViewController:
                makeScene(scene: .home(HomeViewModel(dependency: .init(coordinator: self)))).then {
                    $0.tabBarItem = .init(title: "홈", image: .init(systemName: "1.circle.fill"), selectedImage: nil) }),
            UINavigationController(rootViewController:
                makeScene(scene: .search(SearchViewModel(dependency: .init(coordinator: self)))).then {
                    $0.tabBarItem = .init(title: "검색", image: .init(systemName: "2.circle.fill"), selectedImage: nil) }),
            UINavigationController(rootViewController:
                makeScene(scene: .sort(GenreViewModel())).then {
                    $0.tabBarItem = .init(title: "장르", image: .init(systemName: "3.circle.fill"), selectedImage: nil) })
        ]
        let rootViewController = MainContainerController(
            dependency: .init(coordinator: self, tabViewControllers: navigationControllers))
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func push(at navigation: Navigation, scene: Scene, animated: Bool) {
        let viewController = makeScene(scene: scene)
        
        guard let navigationController = self.navigationControllers[safe: navigation.rawValue] else { return }
        viewController.hidesBottomBarWhenPushed = true
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(from navigation: Navigation, animated: Bool) {
        guard let navigationController = self.navigationControllers[safe: navigation.rawValue] else { return }
        if navigationController.viewControllers.count == 2 {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
        navigationController.popViewController(animated: animated)
    }
    
    
    func modal(at parentViewController: UIViewController, scene: Scene, animated: Bool, completion:(() -> Void)? = nil) {
        let viewController = makeScene(scene: scene).then {
            $0.modalPresentationStyle = .fullScreen
        }
        
        parentViewController.present(viewController, animated: animated, completion: completion)
    }
    
    func dismiss(viewController: UIViewController, animated: Bool, completion:(() -> Void)? = nil) {
        viewController.dismiss(animated: animated, completion: completion)
    }
    
}
