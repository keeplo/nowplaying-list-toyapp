//
//  JSONDecoder+.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/26.
//

import Foundation

extension JSONDecoder {
    
    convenience init(keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
    }
    
}
