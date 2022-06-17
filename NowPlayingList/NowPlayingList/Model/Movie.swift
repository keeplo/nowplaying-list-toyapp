//
//  Movie.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

struct Movie: Identifiable, Decodable {
    
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String?
    let rated: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, releaseDate, posterPath
        case rated = "voteAverage"
    }
    
}
