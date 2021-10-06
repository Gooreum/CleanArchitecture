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

class MyMovieListViewModel: CommonViewModel {
    
    
    var webService: WebServiceType?
    var storage: MovieStorageType? {
        didSet {
            fetchMyMoveList()
        }
    }
    
    private let disposeBag = DisposeBag()
    var myMoveListSubject = BehaviorSubject<[Movie]>(value: [Movie]())
    
    func fetchMyMoveList() {
        if let storage = self.storage {
            storage.myMovieList()
                .subscribe(onNext: { [weak self] in
                    self?.myMoveListSubject.onNext($0)
                })
                .disposed(by: disposeBag)
           
        }else {
            fatalError()
        }
    }
    
//    var myMovieList: Observable<[Movie]> {
//        if let storage = self.storage {
//            storage.myMovieList()
//                .subscribe(onNext: { [weak self] in
//                    self?.myMoveListSubject.onNext($0)
//                })
//                .disposed(by: disposeBag)
//
//        }else {
//            fatalError()
//        }
//    }
}


