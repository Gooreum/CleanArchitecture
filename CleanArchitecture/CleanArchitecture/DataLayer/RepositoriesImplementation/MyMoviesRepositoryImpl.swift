//
//  MyMoviesRepositoryImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/21.
//


import Foundation
import RxSwift

class MyMoviesRepositoryImpl {
    let disposeBag = DisposeBag()
    
    let storage: MyMovieStorageable
    let localMyMoviesMapper = LocalMyMoviesMapper()
    
    init(storage: MyMovieStorageable) {
        self.storage = storage
    }
}

extension MyMoviesRepositoryImpl: MyMoviesRepositoriable {
    func fetchMyMovies() -> Single<[MyMoviesEntity]> {
        return Single.create { [weak self] emitter in
            self?.storage.fetchMyMovieList()
                .subscribe(onSuccess: { movies in
                    emitter(.success(movies))
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
}

