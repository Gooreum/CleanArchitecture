//
//  MyMoviesRepository.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import RxSwift

protocol MyMoviesRepositoriable {
    func fetchMyMovies() -> Single<[MyMoviesEntity]>
}
