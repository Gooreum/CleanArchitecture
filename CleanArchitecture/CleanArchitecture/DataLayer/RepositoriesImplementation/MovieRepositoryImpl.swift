//
//  MovieRepositoryImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import RxSwift

class MovieRepositoryImpl: MovieRepositoriable {
    let disposeBag = DisposeBag()
    
    let webService: WebServiceType
    let storage: MovieStorageType
    let networkStateUtil: NetworkState
    let remoteMovieDetailMapper = RemoteMovieDetailMapper()
    
    init(webService: WebServiceType, storage: MovieStorageType, networkStateUtil: NetworkState) {
        self.webService = webService
        self.storage = storage
        self.networkStateUtil = networkStateUtil
    }
    
    func fetchMovieDetail(id: Int) -> Single<[MovieDetailEntity]> {
        return Single.create { emitter in
            if self.networkStateUtil.monitorReachability() == true {
                self.webService.fetchMovieDetailRx(id: id)
                    .subscribe(onSuccess: { movies in
                        emitter(.success(movies))
                    })
                    .disposed(by: self.disposeBag )
            }
            return Disposables.create()
        }
    }
    
    func saveMovie<T>(movie: T) -> Completable {
        return Completable.create { emitter in
            emitter(.completed)
            return Disposables.create()
        }
    }
    
    func deleteMovie<T>(movie: T) -> Completable {
        return Completable.create { emitter in
            emitter(.completed)
            return Disposables.create()
        }
    }
}
