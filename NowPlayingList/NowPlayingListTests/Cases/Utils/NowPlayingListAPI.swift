//
//  NowPlayingListAPI.swift
//  NowPlayingListTests
//
//  Created by Yongwoo Marco on 2022/02/23.
//

import XCTest
@testable import NowPlayingList

class NowPlayingListAPITests: XCTestCase {
    
    func test_nowplaying_makeURL메서드성공시_URL반환() {
        // give
        let stringURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=c496a1635ef74bb8ac4fe2376d400404&language=en-US&page=1"
        let giveURL = URL(string: stringURL)
        // when
        let testURL = NowPlayingListAPI.nowplaying.makeURL()
        // then
        XCTAssertEqual(giveURL?.baseURL, testURL?.baseURL)
        XCTAssertEqual(giveURL?.pathComponents, testURL?.pathComponents)
        XCTAssertEqual(giveURL?.scheme, testURL?.scheme)
    }
    
}
