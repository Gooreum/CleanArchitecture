//
//  MovieDetailUseCase.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/18.
//

import Foundation
import RxSwift

protocol MovieDetailUseCase {
    func fetchMovieDetail(requestModel: MovieIDRequestModel) -> Single<[MovieDetailResponseModel]>
    func saveMovie(requestModel: MovieDetailRequestModel) -> Completable
    func deleteMovie(requestModel: MovieDetailRequestModel) -> Completable
}
