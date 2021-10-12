//
//  EndPoint.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/26.
//

import Foundation

/*
-MovieList
 https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1
-MovieDetail
 https://api.themoviedb.org/3/movie/{movieId}?api_key=<<api_key>>
-MovieImage
 https://image.tmdb.org/t/p/original/8Y43POKjjKDGI9MH89NW0NAzzp8.jpg
*/

let endpoint = "https://api.themoviedb.org/3/movie/"
let imageEndpoint = "https://image.tmdb.org/t/p/original"

//상영중인 영화 리스트
func composeMoviesPlayingUrlRequest(page: Int) -> URL {
   let urlStr = "\(endpoint)now_playing?api_key=\(apiKey)&language=ko&page=\(page)"
   let url = URL(string: urlStr)!
   return url
}

//영화상세정보
func composeMovieDetailUrlRequest(id: Int) -> URL {
   let urlStr = "\(endpoint)\(id)?api_key=\(apiKey)&language=ko"
   let url = URL(string: urlStr)!
   return url
}

//영화이미지
func composeMovieImageUrlRequest(posterPath: String) -> URL {
    let urlStr = "\(imageEndpoint)\(posterPath)"
    let url = URL(string: urlStr)!
    return url
}
