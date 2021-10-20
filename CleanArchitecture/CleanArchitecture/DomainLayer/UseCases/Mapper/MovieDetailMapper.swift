//
//  MovieDetailMapper.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/20.
//

import Foundation
struct MovieDetailMapper : GetDataMapper {
    func entityTorRsponseModel(entity: [E]) -> [RPM] {
        return [RPM(id: entity[0].id, title: entity[0].title, posterPath: entity[0].posterPath, overview: entity[0].overview, releaseDate: entity[0].releaseDate)]
    }
}
