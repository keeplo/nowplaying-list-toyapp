//
//  Page.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

struct Page: Decodable {
    
    static let base = Page(page: 1, results: [], totalPages: 0, totalResults: 0)
    
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
}
