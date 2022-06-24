//
//  RxViewModel+Protocol.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/06/24.
//

import RxSwift

protocol RxViewModel {
    associatedtype Dependency
    associatedtype Input
    associatedtype Output

    var dependency: Dependency { get }
    var disposeBag: DisposeBag { get set }
    
    var input: Input { get }
    var output: Output { get }
    
    init(dependency: Dependency)
}
