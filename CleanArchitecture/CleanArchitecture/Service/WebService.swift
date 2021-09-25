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
    typealias MoviesDataCompletion = ([Movie]?, WebError?) -> ()

    private func fetchMoviesPlaying(page: Int, completion: @escaping MoviesDataCompletion) {
        let url = composeUrlRequest(endpoint: endpoint, page: page)
        
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
    
    func fetchMoviesPlaying()-> Observable<[Movie]> {
        return Observable.create { observer in
            
            self.fetchMoviesPlaying(page: 1) { (movies, error) in
                if let error = error {
                    print("Failed request from themoviedb: \(error.localizedDescription)")
                    observer.onError(WebError.failedRequest)
                }
                
                if let movies = movies {
                    print(movies)
                    observer.onNext(movies)
                }
                observer.onCompleted()                
            }
            return Disposables.create()
        }
    }
}

