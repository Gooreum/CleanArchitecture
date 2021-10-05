//
//  WebServiceImpl.swift
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

class WebServiceImpl: WebServiceType {
    
    typealias completion<T> = (T?, WebError?) -> ()
    
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
            
//    func fetchMoviesPlaying(page: Int) -> [MoviePlaying] {
//        let url = composeMoviesPlayingUrlRequest(page: page)
//        var moviesPlaying : [MoviePlaying]?
//
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: MoviePlayingResponse.self) { response in
//            guard response.error == nil else {
//                print("Failed request from themoviedb: \(response.error!.localizedDescription)")
//                return
//            }
//            if let movies = response.value?.results {
//                print(movies)
//                moviesPlaying = movies
//            }
//        }
//        return moviesPlaying ?? [MoviePlaying]()
//    }
//
//    func fetchMovieDetail(id: Int) -> [Movie] {
//        let url = composeMovieDetailUrlRequest(id: id)
//        var movieDetail = [Movie]()
//
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: MovieResponse.self) { response in
//            guard response.error == nil else {
//                print("Failed request from themoviedb: \(response.error!.localizedDescription)")
//                return
//            }
//            if let movie = response.value?.movie{
//                movieDetail = movie
//            }
//        }
//        return movieDetail
//    }
//

//        func fetchMoviesPlaying(page: Int, completion: @escaping completion<[MoviePlaying]>) {
//            let url = composeMoviesPlayingUrlRequest(page: page)
//
//            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: MoviePlayingResponse.self) { response in
//                guard response.error == nil else {
//                    print("Failed request from themoviedb: \(response.error!.localizedDescription)")
//                    completion(nil, .failedRequest)
//                    return
//                }
//                if let movies = response.value?.results {
//                    return completion(movies, nil)
//                }
//            }
//        }
//
//    func fetchMovieDetail(id: Int, completion: @escaping completion<[Movie]>) {
//        let url = composeMovieDetailUrlRequest(id: id)
//
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: MovieResponse.self) { response in
//            guard response.error == nil else {
//                print("Failed request from themoviedb: \(response.error!.localizedDescription)")
//                completion(nil, .failedRequest)
//                return
//            }
//            if let movies = response.value?.movie {
//                return completion(movies, nil)
//            }
//        }
//    }

//
//    func fetchMoviesPlaying<MoviePlaying>(page: Int) -> Observable<MoviePlaying> {
//        return Observable.create { observer in
//            let url = composeMoviesPlayingUrlRequest(page: page)
//
//            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).validate().responseDecodable(of: MoviePlayingResponse.self) { response in
//
//                switch response.result {
//                case .success(let result):
//                    observer.onNext(result.results as! MoviePlaying)
//                    observer.onCompleted()
//                case .failure(let error) :
//                    print(error.localizedDescription)
//                    observer.onError(WebError.invalidResponse)
//                }
//            }
//            return Disposables.create()
//        }
//    }
    
//    func fetchMovieDetail<Movie>(id: Int) -> Observable<Movie> {
//        return Observable.create { observer in
//            let url = composeMovieDetailUrlRequest(id: id)
//
//            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).validate().responseDecodable(of: MovieResponse.self) { response in
//                guard response.error != nil else {
//                    observer.onError(WebError.invalidResponse)
//                    return
//                }
//
//                guard let movie = response.value?.movie else {
//                    observer.onError(WebError.invalidData)
//                    return
//                }
//                observer.onNext(movie as! Movie)
//                observer.onCompleted()
//            }
//            return Disposables.create()
//        }
//    }
}


