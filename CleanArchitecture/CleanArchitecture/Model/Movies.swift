//
//  File.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/24.
//

struct Movie: Codable {
    let id: Int
    let title : String
    let overview: String
    let release_date: String
}

struct MovieResponse:Codable {
    let page: Int
    let dates: [String: String]
    let results: [Movie]
}
