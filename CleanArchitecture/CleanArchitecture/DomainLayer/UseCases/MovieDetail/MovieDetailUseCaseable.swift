//
//  MovieDetailUseCase.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/18.
//

import Foundation
import RxSwift

protocol MovieDetailUseCaseable {
    func fetchMovieDetail(requestModel: MovieIDRequestModel) -> Single<[MovieDetailResponseModel]>
    func checkMovieInStore(requestModel: MovieDetailRequestModel) -> Observable<Bool>
    func saveMovie(requestModel: MovieDetailRequestModel) -> Completable
    func deleteMovie(requestModel: MovieDetailRequestModel) -> Completable
}
