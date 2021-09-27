//
//  MovieViewModel.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/26.
//

import Foundation
import RxSwift

class MovieViewModel {
    
    private let webService: WebService
    
    init() {
        self.webService = WebService()
    }
    
    func convertMovieDataAsStream(id: Int)-> Observable<[Movie]> {
        return Observable.create { observer in

            self.webService.fetchMovieDetail(id: id) { (movie, error) in
                if let error = error {
                    print("Failed request from themoviedb: \(error.localizedDescription)")
                    observer.onError(WebError.failedRequest)
                }
                if let movie = movie {
                    print(movie)
                    observer.onNext(movie)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
//    var movie: Movie
//
//    init(movie: Movie, sceneCoordinator: SceneCoordinatorType, storage: MovieType) {
//        self.movie = movie
//        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
//    }
    
//    var movieDetail: Observable<[Movie]> {
//        guard let id = movie.id else {
//            fatalError("There is no movie id")
//        }
//        return storage.movieDetail(id: id)
//    }
}
