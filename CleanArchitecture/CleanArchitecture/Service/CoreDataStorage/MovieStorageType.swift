//
//  MovieStorageType.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/27.
//

import Foundation
import RxSwift

protocol MovieStorageType {    
    //영화 추가하기
    @discardableResult
    func save(movie: MyMovie) -> Observable<MyMovie>    
        
    //내 영화 리스트 가져오기
    @discardableResult
    func myMovieList() -> Observable<[MyMovie]>
    
    //비교하기
    @discardableResult
    func compare(movie: MyMovie) -> Observable<Bool>
    
    //내 영화 삭제하기
    @discardableResult
    func delete(movie: MyMovie) -> Observable<MyMovie>
    
}
