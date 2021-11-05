//
//  MovieRepositoryImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import RxSwift

class MovieRepositoryImpl {
    let disposeBag :DisposeBag
    
    let webService: WebServiceType
    let storage: MyMovieStorageable
    let networkStateUtil: NetworkState
    let remoteMovieDetailMapper = RemoteMovieDetailMapper()
    
    init(webService: WebServiceType, storage: MyMovieStorageable, networkStateUtil: NetworkState) {
        self.webService = webService
        self.storage = storage
        self.networkStateUtil = networkStateUtil
        self.disposeBag = DisposeBag()
    }
}

extension MovieRepositoryImpl: MovieRepositoriable {
    func fetchMovieDetail(id: Int) -> Single<[MovieDetailEntity]> {
        return Single.create { [weak self] emitter in
            if self?.networkStateUtil.monitorReachability() == true {
                self?.webService.fetchMovieDetailRx(id: id)
                    .subscribe(onSuccess: { movies in
                        emitter(.success(movies))
                    })
                    .disposed(by: self?.disposeBag ?? DisposeBag() )
            }
            return Disposables.create()
        }
    }
    
    func checkMovieInStore(movie: MovieDetailEntity) -> Observable<Bool> {
        return Observable.create { [weak self] emitter in
            self?.storage.checkMovieInStore(movie: movie)
                .subscribe(onNext: { emitter.onNext($0) })
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    func saveMovie(movie: MovieDetailEntity) -> Completable {
        return Completable.create { [weak self] emitter in
            self?.storage.save(movie: movie)
                .subscribe()
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
    
    func deleteMovie(movie: MovieDetailEntity) -> Completable {
        return Completable.create { [weak self] emitter in
            self?.storage.delete(movie: movie)
                .subscribe()
                .disposed(by: self?.disposeBag ?? DisposeBag())
            return Disposables.create()
        }
    }
}
