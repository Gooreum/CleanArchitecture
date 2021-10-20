//
//  WebServiceImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/25.
//


import Foundation
import RxSwift
import Alamofire
import AlamofireImage

enum WebError: Error {
    case networkUnable
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class WebServiceImpl: WebServiceType {
    
    typealias completion<T> = (T?, WebError?) -> ()
   
    let networkState = NetworkState()
    
    func fetchMoviesPlaying(page: Int, completion: @escaping completion<[Movie]>) {
        let url = composeMoviesPlayingUrlRequest(page: page)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: MoviePlayingResponse.self) { response in
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
    
    
    func fetchMovieDetail(id: Int, completion: @escaping completion<[Movie]>) {
        let url = composeMovieDetailUrlRequest(id: id)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: Movie.self) { response in
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
    
    func fetchMoviesPlayingRx(page: Int) -> Single<[Movie]> {
        return Single<[Movie]>.create { [weak self] emitter in
                self?.fetchMoviesPlaying(page: page) { movies, error in
                    guard error == nil else {
                        emitter(.failure(WebError.failedRequest))
                        return
                    }
                    if let movies = movies {
                        emitter(.success(movies))
                    }else {
                        emitter(.failure(WebError.invalidData))
                    }
                }         
            return Disposables.create()
        }
    }
}

