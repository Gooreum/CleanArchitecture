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
    
    var myMoveListSubject = BehaviorSubject<[MyMoviesResponseModel]>(value: [MyMoviesResponseModel]())
    let myMoviesUsecase: MyMoviesUseCaseable
    
    init(myMoviesUsecase: MyMoviesUseCaseable) {
        self.myMoviesUsecase = myMoviesUsecase
        fetchMyMoveList()
    }
    
    func fetchMyMoveList() {
        myMoviesUsecase.fetchMyMovies(requestModel: MyMoviesRequestModel())
            .debug("[MyMovieListViewMdoel] fetchMyMovieList() / storage.myMovieList()")
            .subscribe(onSuccess: { [weak self] in
                self?.myMoveListSubject.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}


