//
//  RemoteMoviesPlayingMapper.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/21.
//

import Foundation

struct RemoteMoviesPlayingMapper {
    func remoteMoviesPlayingItemToMovieItem(remoteMoviesPlayingItem: [RemoteMoviesPlayingItem]) -> [MoviesPlayingEntity] {
        var movieList : [MoviesPlayingEntity] = []        
        remoteMoviesPlayingItem.forEach {
            movieList.append(MoviesPlayingEntity(id: $0.id, title: $0.title, posterPath: $0.posterPath, overview: $0.overview, releaseDate: $0.releaseDate))
        }
        return movieList
    }
}
