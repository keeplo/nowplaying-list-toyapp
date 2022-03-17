//
//  Array+.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/03/17.
//

import Foundation.NSArray

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
}
