//
//  MovieDetailUseCaseImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/18.
//

import Foundation
import RxSwift

class MovieDetailUseCaseImpl: MovieDetailUseCase {
    
    var movieRepository: MovieRepositoriable
    let movieDetailMapper: MovieDetailMapper = MovieDetailMapper()
    
    init(movieRepository: MovieRepositoriable) {
        self.movieRepository = movieRepository
    }
    
    func fetchMovieDetail(requestModel: MovieIDRequestModel) -> Single<[MovieDetailResponseModel]> {
        return movieRepository.fetchMovieDetail(id: requestModel.id)
            .map {[weak self] movie in (self?.movieDetailMapper.entityTorRsponseModel(entity: movie))!}
    }
    
    func saveMovie(requestModel: MovieDetailRequestModel) -> Completable {
        return Completable.empty()
        //movieRepositoriable.saveMovie(movie: requestModel)
    }
    
    func deleteMovie(requestModel: MovieDetailRequestModel) -> Completable {
        return Completable.empty()
        //movieRepositoriable.deleteMovie(movie: requestModel)
    }
}
