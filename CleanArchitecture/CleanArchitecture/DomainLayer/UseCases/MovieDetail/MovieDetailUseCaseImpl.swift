//
//  MovieDetailUseCaseImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/18.
//

import Foundation
import RxSwift

final class MovieDetailUseCaseImpl {
    let movieRepository: MovieRepositoriable
    let movieDetailMapper: MovieDetailMapper = MovieDetailMapper()
    
    init(movieRepository: MovieRepositoriable) {
        self.movieRepository = movieRepository
    }
}

extension MovieDetailUseCaseImpl: MovieDetailUseCaseable {
    func fetchMovieDetail(requestModel: MovieIDRequestModel) -> Single<[MovieDetailResponseModel]> {
        return movieRepository.fetchMovieDetail(id: requestModel.id)
            .map {[weak self] movie in (self?.movieDetailMapper.entityToRsponseModel(entity: movie))!}
    }
    
    func checkMovieInStore(requestModel: MovieDetailRequestModel) -> Observable<Bool> {
        let movieDetailEntity = movieDetailMapper.requestModelToEntity(requestModel: requestModel)
        return movieRepository.checkMovieInStore(movie: movieDetailEntity)
    }
    
    func saveMovie(requestModel: MovieDetailRequestModel) -> Completable {
        return movieRepository.saveMovie(movie: (movieDetailMapper.requestModelToEntity(requestModel: requestModel)))
    }
    
    func deleteMovie(requestModel: MovieDetailRequestModel) -> Completable {
        return movieRepository.deleteMovie(movie: (movieDetailMapper.requestModelToEntity(requestModel: requestModel)))
    }
}
