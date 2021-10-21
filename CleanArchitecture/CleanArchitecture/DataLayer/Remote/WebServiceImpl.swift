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

class WebServiceImpl {
    let networkState = NetworkState()
    let remoteMovieDetailMapper = RemoteMovieDetailMapper()
    let remoteMoviesPlayingMapper = RemoteMoviesPlayingMapper()
    
    func fetchMoviesPlaying(page: Int, completion: @escaping completion<[RemoteMoviesPlayingItem]>) {
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
    
    func fetchMovieDetail(id: Int, completion: @escaping completion<[RemoteMovieItem]>) {
        let url = composeMovieDetailUrlRequest(id: id)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: RemoteMovieItem.self) { response in
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

extension WebServiceImpl: WebServiceType{
    func fetchMovieDetailRx(id: Int) -> Single<[MovieDetailEntity]> {
        return Single<[MovieDetailEntity]>.create { [weak self] emitter in
                self?.fetchMovieDetail(id: id) { [weak self] movies, error in
                    guard error == nil else {
                        emitter(.failure(WebError.failedRequest))
                        return
                    }
                    if let movies = movies {
                        emitter(.success((self?.remoteMovieDetailMapper.remoteMovieDetailItemToMovieItem(remoteMovieDetailItem: movies))!))
                    }else {
                        emitter(.failure(WebError.invalidData))
                    }
                }
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
    }
    
    func fetchMoviesPlayingRx(page: Int) -> Single<[MoviesPlayingEntity]> {
        return Single<[MoviesPlayingEntity]>.create { [weak self] emitter in
                self?.fetchMoviesPlaying(page: page) { movies, error in
                    guard error == nil else {
                        emitter(.failure(WebError.failedRequest))
                        return
                    }
                    if let movies = movies {
                        emitter(.success((self?.remoteMoviesPlayingMapper.remoteMoviesPlayingItemToMovieItem(remoteMoviesPlayingItem: movies))!))
                    }else {
                        emitter(.failure(WebError.invalidData))
                    }
                }
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
    }
}

