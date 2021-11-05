//
//  FetchMyMoviesUseCase.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/18.
//

import Foundation
import RxSwift

protocol MyMoviesUseCaseable {
    func fetchMyMovies(requestModel: MyMoviesRequestModel) -> Single<[MyMoviesResponseModel]>
}
