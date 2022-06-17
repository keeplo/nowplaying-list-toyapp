//
//  DetailViewModel.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/06/17.
//

import Foundation

final class DetailViewModel {
    
    struct Dependency {
        let movie: Movie
    }
    
    private let dependency: Dependency
    var title: String {
        dependency.movie.title
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
}
