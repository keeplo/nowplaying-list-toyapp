//
//  Configurable.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/26.
//

import UIKit

protocol Configurable {
    func configureData<T>(_ data: T)
    func configureImage(_ image: UIImage)
}
