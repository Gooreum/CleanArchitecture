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
    
    let disposeBag = DisposeBag()
    
    let moviesSubject = BehaviorSubject<[Movie]>(value: [])
    
    //refresh
    private let refresshingActivating = BehaviorSubject<Bool>(value: false)
    let refreshingActivated: Observable<Bool>
    let refreshingfetching = PublishSubject<Void>()
    
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
        
        refreshingActivated = refresshingActivating.distinctUntilChanged()
        paginationActivated = paginationActivating.distinctUntilChanged()
        
        //새로고침 처리
        refreshingfetching
            .do(onNext: { self.refresshingActivating.onNext(true)})
            .flatMapLatest {
                Observable.deferred {
                    networkStateUtil.monitorReachability() == true ? webService.fetchMoviesPlayingRx(page: 1) : storage.myMovieList()
                }
            }
            .do(onNext: { _ in self.refresshingActivating.onNext(false) })
            .subscribe(onNext: { [weak self] in
                self?.moviesSubject.onNext($0)
                //페이지 추가
                self?.page += 1
                
            })
            .disposed(by: disposeBag)
        
        //페이징 처리
        paginationfetching
            .do(onNext: { self.paginationActivating.onNext(true)})
                .flatMap {
                    Observable.deferred { webService.fetchMoviesPlayingRx(page: self.page) }
                }
                .debug()
                .do(onNext: { _ in self.paginationActivating.onNext(false) })
                    .subscribe(onNext: {[weak self] in
                        do {
                            //moviesSubject(BehaviorSubject)가 가지고 있던 기존 영화 데이터들을 새로운 영화 데이터와 합쳐준다..
                            //이렇게 해도 되는건가..
                            let oldMovies = try self?.moviesSubject.value() ?? [Movie]()
                            self?.moviesSubject.onNext(oldMovies + $0)
                        }catch(let error) {
                            print(error)
                            self?.moviesSubject.onError(error)                            
                        }
                        //페이지 추가
                        self?.page += 1
                    })
                    .disposed(by: disposeBag)
                    }
}

/*
 페이징 처리해야 될 작업
 1.액티비티 인디케이터 보여주기 / 숨기기
 */
