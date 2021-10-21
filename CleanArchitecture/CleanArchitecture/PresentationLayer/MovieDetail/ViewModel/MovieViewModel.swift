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
    
    var buttonEnabled = BehaviorSubject<Bool>(value: false)
    var movieSubject = PublishSubject<[MovieDetailResponseModel]>()
    let movieDetailUseCase: MovieDetailUseCaseable
    
    init(movieDetailUseCase: MovieDetailUseCaseable) {
        self.movieDetailUseCase = movieDetailUseCase
    }
    
    func fetchMovieDetail(id: Int) {
        movieDetailUseCase.fetchMovieDetail(requestModel: MovieIDRequestModel(id: id))
            .subscribe(onSuccess: { [weak self] movie in
                self?.movieSubject.onNext(movie)
            })
            .disposed(by: disposeBag)
    }
    //영화 저장
    //    func saveMovie(movie: Movie) {
    //        storage.save(movie: movie)
    //            .debug()
    //            .subscribe(onCompleted: { [weak self] in
    //                self?.buttonEnabled.onNext(true)
    //            })
    //            .disposed(by: disposeBag)
    //    }
    //
    //    //영화 조회
    //    func checkMovieInStorage(movie: Movie) {
    //        storage.checkMovieInStore(movie: movie)
    //            .do(onNext: {print($0)})
    //            .subscribe(onNext: { [weak self] in
    //                self?.buttonEnabled.onNext($0)
    //            })
    //            .disposed(by: disposeBag)
    //    }
    //
    //    //영화 삭제
    //    func deleteMovie(movie: Movie) {
    //        storage.delete(movie: movie)
    //            //.do(onNext: {print($0)})
    //            .subscribe(onCompleted: { [weak self] in
    //                self?.buttonEnabled.onNext(false)
    //            })
    //            .disposed(by: disposeBag)
    //    }
    
    
}

