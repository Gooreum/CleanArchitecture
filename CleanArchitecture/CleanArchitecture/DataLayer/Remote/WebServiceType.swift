//
//  WebServiceType.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/29.
//

import Foundation
import RxSwift

protocol WebServiceType {
    
    typealias completion<T> = (T?, WebError?) -> ()
    
    //func fetchMoviesPlaying(page: Int, completion: @escaping completion<[RemoteMoviesPlayingItem]>)
    func fetchMoviesPlayingRx(page: Int) -> Single<[MoviesPlayingEntity]>
    //func fetchMovieDetail(id: Int, completion: @escaping completion<[RemoteMovieItem]>)
    func fetchMovieDetailRx(id: Int) -> Single<[MovieDetailEntity]>
    
}
