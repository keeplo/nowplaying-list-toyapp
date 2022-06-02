//
//  Strings.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/27.
//

enum Strings: String, CustomStringConvertible{
    static let emptyString: String = ""
    static let starText: String = "★"
    
    case appTitle
    
    var description: String {
        switch self {
        case .appTitle:
            return "NowPlayingList"
        }
    }
    
    enum Navigation: CustomStringConvertible {
        case nowplaying
        case searching
        case sorting
        case detail
        
        var description: String {
            switch self {
            case .nowplaying:
                return "현재 상영 중"
            case .searching:
                return "검색"
            case .sorting:
                return "장르"
            case .detail:
                return ""
            }
        }
    }
    
    enum SearchBar: CustomStringConvertible {
        case placeholder
        
        var description: String {
            switch self {
            case .placeholder:
                return "Search"
            }
        }
    }
}
