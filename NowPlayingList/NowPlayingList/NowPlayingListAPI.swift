//
//  NowPlayingListAPI.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/21.
//

import Foundation

enum NowPlayingListAPI {
    private static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let apiKey = plist.object(forKey: "APIKey") as? String else {
            NSLog("Couldn't find file 'WeatherInfo.plist'.")
            return ""
        }
        
        return apiKey
    }
    
    private static let scheme = "https"
    private static let host = "api.themoviedb.org"
    private static let appID = NowPlayingListAPI.apiKey

    case nowplaying
    case searching(String)
    
    private var path: String {
        switch self {
        case .nowplaying:
            return "/3/movie/now_playing"
        case .searching(_):
            return "/3/search/movie"
        }
    }
    
    private var keys: [String] {
        switch self {
        case .nowplaying:
            return ["api_key", "language", "page"]
        case .searching(_):
            return ["query", "api_key", "language", "page"]
        }
    }
    
    private var values: [String] {
        var parameters: [String]
        switch self {
        case .searching(let query):
            parameters = [query]
        default:
            parameters = []
        }
        parameters.append(NowPlayingListAPI.appID)
        parameters.append("ko")
        return parameters
    }
}

// MARK: -- Method
extension NowPlayingListAPI {
    static func makeImageURL(_ filePath: String) -> URL? {
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        return URL(string: baseURL + filePath)
    }
    
    func makeURL() -> URL? {
        var components = URLComponents()
        components.scheme = NowPlayingListAPI.scheme
        components.host = NowPlayingListAPI.host
        components.path = path
        
        let queryDictionary = Dictionary(uniqueKeysWithValues: zip(self.keys, self.values))
        let queryItems = queryDictionary.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        components.queryItems = queryItems
        return components.url
    }
}
