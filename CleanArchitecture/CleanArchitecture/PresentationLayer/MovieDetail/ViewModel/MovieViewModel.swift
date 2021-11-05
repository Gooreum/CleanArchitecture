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
    func saveMovie(movie: MovieDetailRequestModel) {
        movieDetailUseCase.saveMovie(requestModel: movie)
            .debug()
            .subscribe(onCompleted: { [weak self] in
                self?.buttonEnabled.onNext(true)
            })
            .disposed(by: disposeBag)
    }
    
    //영화 조회
    func checkMovieInStorage(movie: MovieDetailRequestModel) {
        movieDetailUseCase.checkMovieInStore(requestModel: movie)
            .subscribe(onNext: { [weak self] in
                self?.buttonEnabled.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
    //영화 삭제
    func deleteMovie(movie: MovieDetailRequestModel) {
        movieDetailUseCase.deleteMovie(requestModel: movie)
            .subscribe(onCompleted: { [weak self] in                
                self?.buttonEnabled.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func moviesPlayingResponseModelToMovieDetailRequestModel(responseModel: MoviesPlayingResponseModel) -> MovieDetailRequestModel {
        return MovieDetailRequestModel(id: responseModel.id, title: responseModel.title , posterPath: responseModel.posterPath , overview: responseModel.overview , releaseDate: responseModel.releaseDate )
    }
}

