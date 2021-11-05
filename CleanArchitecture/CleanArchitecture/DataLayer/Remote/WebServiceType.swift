//
//  WebServiceType.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/29.
//

import Foundation
import RxSwift

protocol WebServiceType {    
    func fetchMoviesPlayingRx(page: Int) -> Single<[MoviesPlayingEntity]>
    func fetchMovieDetailRx(id: Int) -> Single<[MovieDetailEntity]>
}
