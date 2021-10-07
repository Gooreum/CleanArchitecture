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
    
    let disposeBag = DisposeBag()
    
    //let movieSubject = PublishSubject<[Movie]>()
    
    //    // INPUT
    //    let fetchMovies: AnyObserver<Void>
    //
    //
    //    // OUTPUT
    //    let activated: Observable<Bool>
    //
    //    let fetching: PublishSubject<Void>
    
    
    // INPUT
    let fetchMovies: AnyObserver<Void>
        
    // OUTPUT
    let activated: Observable<Bool>
    let moviesSubject = BehaviorSubject<[Movie]>(value: [])
    
    
    private let fetching = PublishSubject<Void>()
    private let activating = BehaviorSubject<Bool>(value: false)
    
    var webService: WebServiceType? {
        didSet {
            
            fetching
                .do(onNext: { self.activating.onNext(true)})
                .flatMap {self.webService?.fetchMoviesPlayingRx(page: 1) ?? Observable.just([])}                
                //.do(onNext: { self.activating.onNext(false) })
                .do(onCompleted: {self.activating.onNext(false) })
                .subscribe(onNext: {self.moviesSubject.onNext($0)})
                .disposed(by: disposeBag)
        }
    }
    
    var storage: MovieStorageType?
    
    init() {
        
        // INPUT
        fetchMovies = fetching.asObserver()
        // OUTPUT
        activated = activating.distinctUntilChanged()
        // allMenus = menus
        
        
    }
}


//Subject로 변경필요.
//Viewmodel에서 구독 및 발행이 다 이루어지도록 처리.
//이 로직은 refresh 및 이전작업 취소시 문제가 발생할 수 있음

//    //                //현재 상영중인 영화 가져오기
//                    self.webService?.fetchMoviesPlaying(page: 1){ (movies, error) in
//                        if let error = error {
//                            print("Failed request from themoviedb: \(error.localizedDescription)")
//                            self.movieSubject.onError(WebError.invalidResponse)
//                        }
//
//                        if let movies = movies {
//                            self.movieSubject.onNext(movies)
//                            print(movies)
//                        }else {
//                            self.movieSubject.onError(WebError.invalidData)
//                        }
//                    }
    
