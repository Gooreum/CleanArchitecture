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


struct ResponseToGetMovie {
    let page: Int
    let movieList: [Movie]
}

class MoviesPlayingListViewModel {
    
    private let disposeBag = DisposeBag()
    
    let moviesRelay = BehaviorRelay<[Movie]>(value: [])
    let movieListPage = BehaviorRelay<Int>(value: 1)
    
    //refresh
    private let refreshActivating = BehaviorSubject<Bool>(value: false)
    let refreshActivated: Observable<Bool>
    
    //pagination
    private let paginationActivating = BehaviorSubject<Bool>(value: false)
    let paginationActivated: Observable<Bool>
    
    //fetchAPI
    let fetch = PublishSubject<Int>()
        
    var webService: WebServiceType
    var storage: MovieStorageType
    var networkStateUtil: NetworkState
    
    init(webService: WebServiceType, storage: MovieStorageType, networkStateUtil: NetworkState) {
        self.webService = webService
        self.storage = storage
        self.networkStateUtil = networkStateUtil
        
        refreshActivated = refreshActivating.distinctUntilChanged()
        paginationActivated = paginationActivating.distinctUntilChanged()
        
        //fetching 처리
        fetch
            .debug("paginationFetching ::::: ")
            .do(onNext: { [weak self] page in
                page == 1 ? self?.refreshActivating.onNext(true) : self?.paginationActivating.onNext(true)})
            .concatMap { page in
                Observable.deferred {
                    //MARK: TODO - 에러처리하기
                    networkStateUtil.monitorReachability() == true ? webService.fetchMoviesPlayingRx(page: page).map{ ResponseToGetMovie(page: page, movieList: $0) }.asObservable() : Observable.empty()
                }
            }
            .debug("concatMap ::::: ")
            .do(onNext: { [weak self] _ in  self?.refreshActivating.onNext(false); self?.paginationActivating.onNext(false) })
            .debug("activating ::::: ")
            .scan(into: [Movie]()) { current, item in
                if item.page != 1 && networkStateUtil.monitorReachability() == true {
                    current.append(contentsOf: item.movieList)
                }else {                    
                    current = item.movieList
                }
            }
            .subscribe(onNext: {[weak self] movie in
                self?.moviesRelay.accept(movie)
                })
            .disposed(by: disposeBag)
        }
}