//
//  WebService.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/25.
//


import Foundation
import RxSwift
import Alamofire

enum WebError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class WebService {
    typealias completion<T> = (T?, WebError?) -> ()    

    func fetchMoviesPlaying(page: Int, completion: @escaping completion<[MyMovie]>) {
        let url = composeMoviesPlayingUrlRequest(page: page)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: MovieResponse.self) { response in
            guard response.error == nil else {
                print("Failed request from themoviedb: \(response.error!.localizedDescription)")
                completion(nil, .failedRequest)
                return
            }
            if let movies = response.value?.results {
                return completion(movies, nil)
            }
        }
    }
    
    func fetchMovieDetail(id: Int, completion: @escaping completion<[MyMovie]>) {
        let url = composeMovieDetailUrlRequest(id: id)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: MyMovie.self) { response in
            guard response.error == nil else {
                print("Failed request from themoviedb: \(response.error!.localizedDescription)")
                completion(nil, .failedRequest)
                return
            }
            if let movie = response.value {
                return completion([movie], nil)
            }
        }
    }
}

