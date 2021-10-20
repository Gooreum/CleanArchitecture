//
//  MyMovie.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/29.
//

import Foundation

struct MovieDetailEntity : Entity{
    let id: Int
    let title: String?
    let posterPath: String?
    let overview: String?
    let releaseDate: String?
}
