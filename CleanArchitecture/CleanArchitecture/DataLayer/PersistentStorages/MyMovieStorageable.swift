//
//  MyMovieStorageable.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/27.
//

import Foundation
import RxSwift

protocol MyMovieStorageable {    
    //영화 추가하기
    @discardableResult
    func save(movie: MovieDetailEntity) -> Completable
        
    //내 영화 리스트 가져오기
    @discardableResult
    func fetchMyMovieList() -> Single<[MyMoviesEntity]>
    
    //비교하기
    @discardableResult
    func checkMovieInStore(movie: MovieDetailEntity) -> Observable<Bool>
    
    //내 영화 삭제하기
    @discardableResult
    func delete(movie: MovieDetailEntity) -> Completable
}
