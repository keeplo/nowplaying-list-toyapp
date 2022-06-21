//
//  NowPlayingListAPI.swift
//  NowPlayingListTests
//
//  Created by Yongwoo Marco on 2022/02/23.
//

import XCTest
@testable import NowPlayingList

class NowPlayingListAPITests: XCTestCase {
    
    func test_API_fetch메서드_Page데이터_불러오기() {
        // give
        let basePage = Page.base
        
        // when
        let request = API.fetch(page: basePage.page)
        
        request.request { result in
            // then
            switch result {
            case .success(_):
                XCTAssertTrue(true)
            case .failure(_):
                XCTAssertTrue(false)
            }
        }
        
    }
    
}
