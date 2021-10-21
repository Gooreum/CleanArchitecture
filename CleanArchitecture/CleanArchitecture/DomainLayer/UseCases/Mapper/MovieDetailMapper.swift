//
//  MovieDetailMapper.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/20.
//

import Foundation
import Alamofire

struct MovieDetailMapper : GetDataMapperable {
    func entityToRsponseModel(entity: [MovieDetailEntity]) -> [MovieDetailResponseModel] {
        return [MovieDetailResponseModel(id: entity[0].id, title: entity[0].title, posterPath: entity[0].posterPath, overview: entity[0].overview, releaseDate: entity[0].releaseDate)]
    }
}
