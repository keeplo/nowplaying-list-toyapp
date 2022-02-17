//
//  Movie.swift
//  NowPlayingList
//
//  Created by Yongwoo Marco on 2022/02/17.
//

struct Movie: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let imagePath: String
    let rated: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, releaseDate
        case imagePath = "posterPath"
        case rated = "voteAverage"
    }
}
