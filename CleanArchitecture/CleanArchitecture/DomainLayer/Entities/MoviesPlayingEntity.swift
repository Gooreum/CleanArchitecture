//
//  MoviesPlayingEntity.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/21.
//

import Foundation

struct MoviesPlayingEntity : Entity {
    let id: Int
    let title: String
    let posterPath: String
    let overview: String
    let releaseDate: String
}
