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

class MoviesPlayingListViewModel: CommonViewModel {
    
    let disposeBag = DisposeBag()
        
    let activated: Observable<Bool>
    let moviesSubject = BehaviorSubject<[Movie]>(value: [])
    
    let fetching = PublishSubject<Void>()
    private let activating = BehaviorSubject<Bool>(value: false)
    
    //MARK: TODO - 네트워크 상태에 따른 데이터 처리
    //1.네트워크 상태를 체크하는 Util을 새로 만든다.(의존성 주입을 받는다.)
    //2.상태에 따라 API 통신할지, 로컬DB에서 가져온다.
        
    var webService: WebServiceType?
    var storage: MovieStorageType?
    var networkStateUtil: NetworkState?
    
    init(webService: WebServiceType, storage: MovieStorageType, networkStateUtil: NetworkState) {
        self.webService = webService
        self.storage = storage
        self.networkStateUtil = networkStateUtil
        
        //let state = self.networkStateUtil?.monitorReachability()
//        print(state)
        
        activated = activating.distinctUntilChanged()
        fetching
            .do(onNext: { self.activating.onNext(true)})
            //.flatMap {self.webService!.fetchMoviesPlayingRx(page: 1)}
            .flatMapLatest {
                Observable.deferred {
                    self.networkStateUtil?.monitorReachability() == true ? self.webService!.fetchMoviesPlayingRx(page: 1) : self.storage!.myMovieList()
                }
            }
            .do(onNext: { _ in
                self.activating.onNext(false) })
            .subscribe(onNext: {self.moviesSubject.onNext($0)})
            .disposed(by: disposeBag)
    }    
}
