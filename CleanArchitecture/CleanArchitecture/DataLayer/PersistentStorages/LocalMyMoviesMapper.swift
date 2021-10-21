//
//  LocalMyMoviesMapper.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/22.
//

import Foundation

struct LocalMyMoviesMapper {
    func localMyMoviesItemToMyMoviesItem(localMoviesItem: [LocalMyMoviesItem]) -> [MyMoviesEntity] {
        var movieList : [MyMoviesEntity] = []
        localMoviesItem.forEach {
            movieList.append(MyMoviesEntity(id: $0.id, title: $0.title, posterPath: $0.posterPath, overview: $0.overview, releaseDate: $0.releaseDate))
        }
        return movieList
    }
    
    func myMoviesItemToLocalMyMoviesItem(movieDetailItem: MovieDetailEntity) -> LocalMyMoviesItem {
        return LocalMyMoviesItem(id: movieDetailItem.id, overview: movieDetailItem.overview, releaseDate: movieDetailItem.releaseDate, title: movieDetailItem.title, posterPath: movieDetailItem.posterPath)
    }
}
