//
//  NowPlayingListNetworkManager.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/21.
//

import Foundation

struct NowPlayingListNetworkManager: NetworkManager {
    func loadNowPlayingList(url: URL, _ completion: @escaping (Page) -> Void) {
        requestData(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let page = try decoder.decode(Page.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(page)
                    }
                } catch {
                    NSLog("\(#function) - \(error.localizedDescription)")
                }
            case .failure(let error):
                NSLog("\(#function) - \(error.localizedDescription)")
            }
        }
    }
}
