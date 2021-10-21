//
//  RemoteMoviesPlayingItem.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/21.
//

import Foundation

struct RemoteMoviesPlayingItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
    let id: Int
    let title: String
    let posterPath: String
    let overview: String
    let releaseDate: String
}

struct MoviePlayingResponse: Decodable {
    let page: Int
    let dates: [String: String]
    let results: [RemoteMoviesPlayingItem]
}
