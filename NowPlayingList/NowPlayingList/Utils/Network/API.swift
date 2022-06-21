//
//  NowPlayingListAPI.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/21.
//

import Foundation

enum API {
    
    private static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let apiKey = plist.object(forKey: "APIKey") as? String else {
            NSLog("Couldn't find file 'WeatherInfo.plist'.")
            return ""
        }
        return apiKey
    }
    
    private static let components: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        return components
    }()
    
    private static let appID = API.apiKey

    case nowplaying(Int)
    case searching(String, Int)
    
    private var path: String {
        switch self {
        case .nowplaying:
            return "/3/movie/now_playing"
        case .searching:
            return "/3/search/movie"
        }
    }
    
    private var keys: [String] {
        switch self {
        case .nowplaying:
            return ["page", "api_key", "language"]
        case .searching:
            return ["query", "page", "api_key", "language"]
        }
    }
    
    private var values: [String] {
        var parameters: [String]
        switch self {
        case .nowplaying(let page):
            parameters = [String(page)]
        case .searching(let query, let page):
            parameters = [query, String(page)]
        }
        parameters.append(API.appID)
        parameters.append("ko")
        return parameters
    }
    
    private func makeURL() -> URL? {
        var components = Self.components
        components.path = path
        
        let queryDictionary = Dictionary(
            uniqueKeysWithValues: zip(self.keys, self.values))
        let queryItems = queryDictionary.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        components.queryItems = queryItems
        return components.url
    }
}

// MARK: -- Methods
extension API {
    
    static func fetch(page: Int) -> NetworkRequest<Page> {
        let url = Self.nowplaying(page).makeURL()
        return NetworkRequest(url: url)
    }
    
    static func search(by keyword: String, page: Int) -> NetworkRequest<Page> {
        let url = Self.searching(keyword, page).makeURL()
        return NetworkRequest(url: url)
    }
    
    static func makeImageURL(_ filePath: String) -> URL? {
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        return URL(string: baseURL + filePath)
    }
    
}
