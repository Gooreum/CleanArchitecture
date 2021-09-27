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
    
    func convertMoviesPlayingDataAsStream(page: Int)-> Observable<[Movie]> {
        return Observable.create { observer in

            self.webService.fetchMoviesPlaying(page: page) { (movies, error) in
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
//    var moviePlayingList: Observable<[Movie]> {
//        return storage.playingMovieList(page: 1)
//    }
    
    //클로저 내부에서 셀프로 접근해야 되기 때문에 lazy로 선언
//    lazy var detailAction: Action<Movie, Void> = {
//        return Action { movie in
//            //디테일 뷰 모델 생성
//            let movieViewModel = MovieViewModel(movie: movie, sceneCoordinator: self.sceneCoordinator, storage: self.storage)
//
//            //Scene 생성
//            let movieDetailScene = Scene.movieDetail(movieViewModel)
//
//            return self.sceneCoordinator.transition(to: movieDetailScene, using: .push, animated: true).asObservable().map { _ in }
//        }
//    }()    
}
