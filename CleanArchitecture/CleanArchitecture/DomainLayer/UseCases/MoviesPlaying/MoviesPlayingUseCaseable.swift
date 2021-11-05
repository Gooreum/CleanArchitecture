//
//  MoviesPlayingUseCaseable.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/18.
//

import Foundation
import RxSwift

protocol MoviesPlayingUseCaseable {
    func fetchMoviesPlaying(requestModel: MoviesPlayingRequestModel) -> Single<[MoviesPlayingResponseModel]>    
}
