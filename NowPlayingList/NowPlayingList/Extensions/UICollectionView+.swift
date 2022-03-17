//
//  UICollectionView+.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/03/17.
//

import UIKit.UICollectionView

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(cell.self, forCellWithReuseIdentifier: cell.className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cell: T.Type, at indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withReuseIdentifier: cell.className, for: indexPath) as? T
    }
}

