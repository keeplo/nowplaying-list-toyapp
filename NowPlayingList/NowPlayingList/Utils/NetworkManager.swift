//
//  NowPlayingListNetworkManager.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/21.
//

import Foundation

protocol NetworkManager {
    func requestData(with url: URL, _ completion: @escaping (Result<Data, Error>) -> Void)
}

enum NetworkError: Error {
    case emptyData
}

extension NetworkManager {
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
    
    func requestData(with url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _ , error in
            guard error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    print("Unexpected Error")
                }
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                NSLog("\(#function) - data 없음")
                completion(.failure(NetworkError.emptyData))
            }
        }.resume()
    }
}
