//
//  MyMovieListViewModel.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/28.
//


import Foundation
import RxSwift
import Action
import CoreData

class MyMovieListViewModel {
    
    private let disposeBag = DisposeBag()
    
    var webService: WebServiceType
    var storage: MovieStorageType
    
    var myMoveListSubject = BehaviorSubject<[Movie]>(value: [Movie]())
    
    init(webService: WebServiceType, storage: MovieStorageType) {
        self.webService = webService
        self.storage = storage
        fetchMyMoveList()
    }
    
    func fetchMyMoveList() {
        storage.myMovieList()
            .subscribe(onNext: { [weak self] in
                self?.myMoveListSubject.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}


