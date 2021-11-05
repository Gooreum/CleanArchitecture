//
//  MyMoviesUseCaseImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/18.
//

import Foundation
import RxSwift

final class MyMoviesUseCaseImpl {
    let myMoviesRepository: MyMoviesRepositoriable
    let myMoviesMapper: MyMoviesMapper = MyMoviesMapper()
    
    init(myMoviesRepository: MyMoviesRepositoriable) {
        self.myMoviesRepository = myMoviesRepository
    }
}

extension MyMoviesUseCaseImpl: MyMoviesUseCaseable {
    func fetchMyMovies(requestModel: MyMoviesRequestModel) -> Single<[MyMoviesResponseModel]> {
        return myMoviesRepository.fetchMyMovies()
                .map {[weak self] movie in (self?.myMoviesMapper.entityToRsponseModel(entity: movie))!}
    }
}


