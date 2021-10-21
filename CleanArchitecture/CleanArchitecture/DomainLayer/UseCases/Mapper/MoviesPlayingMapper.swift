//
//  MoviesPlayingMapper.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/21.
//

import Foundation

struct MoviesPlayingMapper : GetDataMapperable {
    func entityToRsponseModel(entity: [MoviesPlayingEntity]) -> [MoviesPlayingResponseModel] {
        var moviesPlayingResponseModel: [MoviesPlayingResponseModel] = []
        entity.forEach { element in
            moviesPlayingResponseModel.append(MoviesPlayingResponseModel(id: element.id, title: element.title, posterPath: element.posterPath, overview: element.overview, releaseDate: element.releaseDate) )
        }
        return moviesPlayingResponseModel
    }
}
