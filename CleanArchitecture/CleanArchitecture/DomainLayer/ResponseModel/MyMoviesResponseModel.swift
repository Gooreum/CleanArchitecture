//
//  MyMoviesResponseModel.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation

struct MyMoviesResponseModel: GetDataResponseModelable {
    let id: Int
    let title: String
    let posterPath: String
    let overview: String
    let releaseDate: String
}
