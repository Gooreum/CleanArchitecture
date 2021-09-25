//
//  EndPoint.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/26.
//

import Foundation


//https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1
let endpoint = "https://api.themoviedb.org/3/movie/now_playing?api_key"

func composeUrlRequest(endpoint: String, page: Int) -> URL {
   let urlStr = "\(endpoint)=\(apiKey)&language=en-US&page=\(page)"
   let url = URL(string: urlStr)!
   return url
}
