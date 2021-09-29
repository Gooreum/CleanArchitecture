//
//  MoviesPlayingListViewModel.swift.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/25.
//

import Foundation
import RxSwift
import Action

class MoviesPlayingListViewModel {
    
    
    private let webService: WebService
    
    init() {
        self.webService = WebService()
    }
    
    func convertMoviesPlayingDataAsStream(page: Int)-> Single<[MyMovie]> {
        return Single.create { observer in
            self.webService.fetchMoviesPlaying(page: page) { (movies, error) in
                if let error = error {
                    print("Failed request from themoviedb: \(error.localizedDescription)")
                    observer(.failure(WebError.failedRequest))
                }
                
                if let movies = movies {
                    observer(.success(movies))
                }else {
                    observer(.failure(WebError.invalidData))
                }
            }
            return Disposables.create()
        }
    }
}
