//
//  MoviesPlayingRepository.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import RxSwift

protocol MoviesPlayingRepositoriable {
    func fetchMoviesPlaying(page: Int) -> Single<[MoviesPlayingEntity]>
}
