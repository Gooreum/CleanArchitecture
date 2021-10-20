//
//  RemoteMovieDetailMapper.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/20.
//

import Foundation

struct RemoteMovieDetailMapper {
    func remoteMovieDetailItemToMovieItem(remoteMovieDetailItem: [RemoteMovieItem]) -> [MovieDetailEntity] {
        var movieList : [MovieDetailEntity] = []
        movieList.append(MovieDetailEntity(id: remoteMovieDetailItem[0].id, title: remoteMovieDetailItem[0].title, posterPath: remoteMovieDetailItem[0].posterPath, overview: remoteMovieDetailItem[0].overview, releaseDate: remoteMovieDetailItem[0].releaseDate))
        return movieList
        
    }
}
