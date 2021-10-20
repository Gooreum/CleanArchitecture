//
//  MovieRepository.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import RxSwift

protocol MovieRepositoriable {
    func fetchMovieDetail(id: Int) -> Single<[MovieDetailEntity]>
    func saveMovie(movie: MovieDetailEntity) -> Completable
    func deleteMovie(movie: MovieDetailEntity) -> Completable
}
