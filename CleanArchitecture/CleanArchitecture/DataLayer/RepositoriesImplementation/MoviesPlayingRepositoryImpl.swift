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
    let storage: MovieStorageType
    let networkStateUtil: NetworkState
    let remoteMovieDetailMapper = RemoteMovieDetailMapper()
    
    init(webService: WebServiceType, storage: MovieStorageType, networkStateUtil: NetworkState) {
        self.webService = webService
        self.storage = storage
        self.networkStateUtil = networkStateUtil
    }
}

extension MoviesPlayingRepositoryImpl: MoviesPlayingRepositoriable {
    func fetchMoviesPlaying(page: Int) -> Single<[MoviesPlayingEntity]> {
        return Single.create { emitter in
            if self.networkStateUtil.monitorReachability() == true {
                self.webService.fetchMoviesPlayingRx(page: page)
                    .subscribe(onSuccess: { movies in
                        emitter(.success(movies))
                    })
                    .disposed(by: self.disposeBag )
            }
            return Disposables.create()
        }
    }
}
