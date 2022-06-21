//
//  NowPlayingListNetworkManager.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/21.
//

import Foundation

enum NetworkError: Error {
    case unknown
    case urlError
    case invalidRequest
    case jsonError
    case serverError
}

struct NetworkRequest<T: Decodable> {

    private var url: URL?

    init(url: URL?) {
        self.url = url
    }
    
    func request(completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.urlError))
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(.serverError))
                return
            }

            guard let data = data else {
                completion(.failure(.unknown))
                return
            }

            do {
                let decodedData: T = try JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase).decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.jsonError))
            }
        }).resume()
    }
    
}

