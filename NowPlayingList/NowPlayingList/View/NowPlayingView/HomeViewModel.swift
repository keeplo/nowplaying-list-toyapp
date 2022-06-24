//
//  HomeViewModel.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: RxViewModel  {
    
    struct Dependency {
        let coordinator: SceneCoordinator
    }
    
    struct Input {}
    
    struct Output {
        var list: Observable<[Movie]>
    }
    
    let dependency: Dependency
    var disposeBag: DisposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private var observableList = PublishSubject<[Movie]>()
    private var page: Page = .base
    private var list: [Movie] = [] {
        didSet {
            observableList.onNext(list)
        }
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        
        // Input & Output
        self.input = Input()
        self.output = Output(
            list: observableList
        )

        // Binding
    }
    
}

extension HomeViewModel {
    
    func fetchList() {
        guard page.page < page.totalPages else { return }
        API.fetch(page: page.page + 1)
            .request(completion: { [weak self] result in
                switch result {
                case .success(let page):
                    self?.page = page
                    self?.list.append(contentsOf: page.results)
                case .failure(let error):
                    debugPrint("\(#function) - local: \(error), description: \(error.localizedDescription)")
                }
            })
    }
    
    func pushDetailView(by model: Movie) {
        dependency.coordinator
            .push(at: .home,
                  scene: .movie(.init(dependency: .init(movie: model))),
                  animated: true)
    }
    
}
