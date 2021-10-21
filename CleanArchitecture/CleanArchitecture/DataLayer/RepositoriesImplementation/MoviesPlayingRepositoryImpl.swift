//
//  MoviesPlayingRepositoryImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/21.
//

import Foundation
import RxSwift

class MoviesPlayingRepositoryImpl {
    let disposeBag = DisposeBag()
    
    let webService: WebServiceType
    let storage: MyMovieStorageable
    let networkStateUtil: NetworkState
    let remoteMovieDetailMapper = RemoteMovieDetailMapper()
    
    init(webService: WebServiceType, storage: MyMovieStorageable, networkStateUtil: NetworkState) {
        self.webService = webService
        self.storage = storage
        self.networkStateUtil = networkStateUtil
    }
}

extension MoviesPlayingRepositoryImpl: MoviesPlayingRepositoriable {
    func fetchMoviesPlaying(page: Int) -> Single<[MoviesPlayingEntity]> {
        return Single.create {[weak self] emitter in
            if self?.networkStateUtil.monitorReachability() == true {
                self?.webService.fetchMoviesPlayingRx(page: page)
                    .subscribe(onSuccess: { movies in
                        emitter(.success(movies))
                    })
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            }
            return Disposables.create()
        }
    }
}
