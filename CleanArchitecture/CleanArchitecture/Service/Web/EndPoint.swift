//
//  EndPoint.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/26.
//

import Foundation

/*
-MovieList
//https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1
-MovieDetail
//https://api.themoviedb.org/3/movie/{movieId}?api_key=<<api_key>>
*/

let endpoint = "https://api.themoviedb.org/3/movie/"

func composeMoviesPlayingUrlRequest(page: Int) -> URL {
   let urlStr = "\(endpoint)now_playing?api_key=\(apiKey)&page=\(page)"
   let url = URL(string: urlStr)!
   return url
}

func composeMovieDetailUrlRequest(id: Int) -> URL {
   let urlStr = "\(endpoint)\(id)?api_key=\(apiKey)"
   let url = URL(string: urlStr)!
   return url
}
