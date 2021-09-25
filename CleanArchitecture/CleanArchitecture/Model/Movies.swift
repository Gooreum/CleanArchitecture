//
//  File.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/24.
//


struct Movies {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case overview
    }
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
}

extension Movies: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        overview = try container.decode(String.self, forKey: .overview)
    }
}
