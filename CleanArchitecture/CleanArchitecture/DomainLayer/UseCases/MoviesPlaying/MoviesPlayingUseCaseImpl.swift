//
//  FetchMoviesPlayingUseCaseImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/18.
//

import Foundation
import RxSwift

final class MoviesPlayingUseCaseImpl {
    let moviesPlayingRepository: MoviesPlayingRepositoriable
    let moviesPlayingMapper: MoviesPlayingMapper = MoviesPlayingMapper()
    
    init(moviesPlayingRepository: MoviesPlayingRepositoriable) {
        self.moviesPlayingRepository = moviesPlayingRepository
    }
}

extension MoviesPlayingUseCaseImpl: MoviesPlayingUseCaseable {
    func fetchMoviesPlaying(requestModel: MoviesPlayingRequestModel) -> Single<[MoviesPlayingResponseModel]> {
        return moviesPlayingRepository.fetchMoviesPlaying(page: requestModel.page)
                .map {[weak self] movie in (self?.moviesPlayingMapper.entityToRsponseModel(entity: movie))!}
    }
}
