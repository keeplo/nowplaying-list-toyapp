//
//  UITableView+.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/03/17.
//

import UIKit.UITableView

extension UITableView {
    
    func register<T: UITableViewCell>(_ cell: T.Type) {
        self.register(cell.self, forCellReuseIdentifier: cell.className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cell: T.Type, at indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: cell.className, for: indexPath) as? T
    }
}

