//
//  MockNetworkManager.swift
//  NowPlayingListTests
//
//  Created by Yongwoo Marco on 2022/02/23.
//

import XCTest
@testable import NowPlayingList

struct MockDecodeRequestable: DecodeRequestable {
    var isSuccess: Bool
    
    func requestData(with url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) {
        if isSuccess {
            completion(.success(Data()))
        } else {
            completion(.failure(NSError()))
        }
    }
    
    func parseRequestedData<T: Decodable>(url: URL, type: T.Type, _ completion: @escaping (T) -> Void) {
        
    }
}
