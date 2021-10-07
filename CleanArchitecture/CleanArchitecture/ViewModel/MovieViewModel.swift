//
//  MovieViewModel.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/26.
//

import Foundation
import RxSwift
import Action

class MovieViewModel {
    
    private let disposeBag = DisposeBag()
    
    var webService: WebServiceType
    var storage: MovieStorageType
    
    var buttonEnabled = BehaviorSubject<Bool>(value: false)
    //var movieSubject = BehaviorSubject<[Movie]>(value: [Movie]())
    var movieSubject = PublishSubject<[Movie]>()
    
    
    init(webService: WebServiceType, storage: MovieStorageType) {
        self.webService = webService
        self.storage = storage
    }
    
    //영화상세정보 가져오기
    func fetchMovieDetail(id: Int) {
        self.webService.fetchMovieDetail(id: id) { [weak self] (movie, error) in
            if let error = error {
                print("Failed request from themoviedb: \(error.localizedDescription)")
                self?.movieSubject.onError(WebError.failedRequest)
            }
            if let movie = movie {
                self?.movieSubject.onNext(movie)
                self?.movieSubject.onCompleted()
            }else {
                self?.movieSubject.onError(WebError.invalidData)
            }
        }
    }
    
    //영화 저장
    func saveMovie(movie: Movie) {
        storage.save(movie: movie)
            .debug()
            .subscribe(onCompleted: { [weak self] in
                self?.buttonEnabled.onNext(true)
            })
            .disposed(by: disposeBag)
    }
    
    //영화 조회
    func checkMovieInStorage(movie: Movie) {
        storage.checkMovieInStore(movie: movie)
            .do(onNext: {print($0)})
            .subscribe(onNext: { [weak self] in
                self?.buttonEnabled.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
    //영화 삭제
    func deleteMovie(movie: Movie) {
        storage.delete(movie: movie)
            //.do(onNext: {print($0)})
            .subscribe(onCompleted: { [weak self] in
                self?.buttonEnabled.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}

