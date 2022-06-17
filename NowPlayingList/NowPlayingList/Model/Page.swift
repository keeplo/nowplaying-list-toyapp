//
//  Page.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

struct Page: Decodable {
    
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
}
