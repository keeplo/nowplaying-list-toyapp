//
//  NetworkManagerTests.swift
//  NowPlayingListTests
//
//  Created by Yongwoo Marco on 2022/02/23.
//

import XCTest
@testable import NowPlayingList

class NetworkManagerTests: XCTestCase {
    var managerSUT: HomeViewModel!
    var mockSUT: MockDecodeRequestable!
    
    override func setUp() {
         super.setUp()
        managerSUT = HomeViewModel()
    }
    
    func test_success_requestData메서드() {
        // give
        let mock = MockDecodeRequestable(isSuccess: true)
        // when
        mock.requestData(with: URL(string: "http://dummy.url")!) { result in
            // then
            switch result {
            case .success(_):
                XCTAssertTrue(true)
            case .failure(_):
                XCTAssertTrue(false)
            }
        }
        
    }
    
    func test_success_loadNowPlayingList메서드_성공하면_데이터반환() {
        // give
        let url = NowPlayingListAPI.nowplaying(1).makeURL()!
        // when
        managerSUT.parseRequestedData(url: url, type: Page.self) { page in
            // then
            print("test_success_requestData메서드_성공하면_데이터반환 - \(page.results.count)")
            XCTAssertFalse(page.results.isEmpty)
        }
    }
    
}
