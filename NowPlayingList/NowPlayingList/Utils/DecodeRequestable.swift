//
//  NowPlayingListNetworkManager.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/21.
//

import Foundation

enum NetworkError: Error {
    case emptyData
}

protocol DecodeRequestable {
    func requestData(with url: URL, _ completion: @escaping (Result<Data, Error>) -> Void)
    func parseRequestedData<T: Decodable>(url: URL, type: T.Type, _ completion: @escaping (T) -> Void)
}

extension DecodeRequestable {
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
    
    func parseRequestedData<T: Decodable>(url: URL, type: T.Type = T.self, _ completion: @escaping (T) -> Void) {
        requestData(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder =  JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let instance = try decoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(instance)
                    }
                } catch {
                    NSLog("\(#function) - 1 \(error.localizedDescription)")
                }
            case .failure(let error):
                NSLog("\(#function) - 2 \(error.localizedDescription)")
            }
        }
    }
}
