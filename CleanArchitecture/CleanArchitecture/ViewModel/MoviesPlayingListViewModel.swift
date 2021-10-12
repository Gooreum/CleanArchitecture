//
//  MoviesPlayingListViewModel.swift.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/25.
//

import Foundation
import RxSwift
import Action
import RxCocoa

class MoviesPlayingListViewModel {
    
    private let disposeBag = DisposeBag()
    
    let moviesRelay = BehaviorRelay<[Movie]>(value: [])
    
    //refresh
    private let refreshActivating = BehaviorSubject<Bool>(value: false)
    let refreshActivated: Observable<Bool>
    let refreshfetching = PublishSubject<Void>()
    
    //pagination
    private let paginationActivating = BehaviorSubject<Bool>(value: false)
    private var page: Int = 1
    let paginationActivated: Observable<Bool>
    let paginationfetching = PublishSubject<Void>()
    var pageSubject = BehaviorSubject<Int>(value: 1)
    
    var webService: WebServiceType
    var storage: MovieStorageType
    var networkStateUtil: NetworkState
    
    init(webService: WebServiceType, storage: MovieStorageType, networkStateUtil: NetworkState) {
        self.webService = webService
        self.storage = storage
        self.networkStateUtil = networkStateUtil
        
        refreshActivated = refreshActivating.distinctUntilChanged()
        paginationActivated = paginationActivating.distinctUntilChanged()
        
        //새로고침 처리
        refreshfetching
            .do(onNext: { self.refreshActivating.onNext(true)})
            .flatMapLatest {
                Observable.deferred {
                    networkStateUtil.monitorReachability() == true ? webService.fetchMoviesPlayingRx(page: 1) : storage.myMovieList()
                }
            }
            .do(onNext: { _ in self.refreshActivating.onNext(false) })
            .subscribe(onNext: { [weak self] in
                self?.moviesRelay.accept($0)
                //페이지 추가
                self?.page += 1
            })
            .disposed(by: disposeBag)
        
        //페이징 처리
        paginationfetching
            .debug("paginationFetching ::::: ")
            .do(onNext: { self.paginationActivating.onNext(true)})
                //왜 concatMap은 안되는지 모르겠네..
            .flatMapLatest {
                Observable.deferred {
                    //MARK: TODO - 에러처리하기
                    networkStateUtil.monitorReachability() == true ? webService.fetchMoviesPlayingRx(page: self.page) : Observable.never()
                }
            }
            .do(onNext: { _ in self.paginationActivating.onNext(false) })
            .subscribe(onNext: {[weak self] in
                    let oldMovies = self?.moviesRelay.value ?? [Movie]()
                    self?.moviesRelay.accept(oldMovies + $0)
                    //페이지 추가
                    self?.page += 1
                })
            .disposed(by: disposeBag)
        }
}
