//
//  MoviesPlayingListViewModel.swift.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/25.
//

import Foundation
import RxSwift
import Action
import RxCocoa

class MoviesPlayingListViewModel: CommonViewModel {
        
    var movieSubject = PublishSubject<[Movie]>()
    let disposeBag = DisposeBag()
    
    
    var webService: WebServiceType? {
        didSet {
            //moviesubject 구독
            self.movieSubject
                .subscribe( onNext: {
                    print($0)
                }, onError: {
                    print($0)
                })
                .disposed(by: self.disposeBag)
            
            //현재 상영중인 영화 가져오기
            self.webService?.fetchMoviesPlaying(page: 1){ (movies, error) in
                if let error = error {
                    print("Failed request from themoviedb: \(error.localizedDescription)")
                    self.movieSubject.onError(WebError.invalidResponse)
                }
                
                if let movies = movies {
                    self.movieSubject.onNext(movies)
                    print(movies)
                }else {
                    self.movieSubject.onError(WebError.invalidData)
                }
            }
        }
    }
    
    var storage: MovieStorageType? {
        didSet {
        }
    }
}


//Subject로 변경필요.
//Viewmodel에서 구독 및 발행이 다 이루어지도록 처리.
//이 로직은 refresh 및 이전작업 취소시 문제가 발생할 수 있음


//self.webService.fetchMoviesPlaying(page: page) { (movies, error) in
//    if let error = error {
//        print("Failed request from themoviedb: \(error.localizedDescription)")
//        observer(.failure(WebError.failedRequest))
//    }
//
//    if let movies = movies {
//        observer(.success(movies))
//    }else {
//        observer(.failure(WebError.invalidData))
//    }
//}
//return Disposables.create()
