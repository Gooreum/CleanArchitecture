//
//  MovieViewModel.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/26.
//

import Foundation
import RxSwift
import Action

class MovieViewModel {
    
    private let disposeBag = DisposeBag()
    private let webService: WebService
    private let storage: CoreDataStorage
    
    init() {
        self.webService = WebService()
        self.storage = CoreDataStorage(modelName: "Model")
    }
    
    func convertMovieDataAsStream(id: Int)-> Observable<[MyMovie]> {
        return Observable.create { observer in
            self.webService.fetchMovieDetail(id: id) { (movie, error) in
                if let error = error {
                    print("Failed request from themoviedb: \(error.localizedDescription)")
                    observer.onError(WebError.failedRequest)
                }
                
                if let movie = movie {
                    observer.onNext(movie)
                }else {
                    observer.onError(WebError.invalidData)
                }
                
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
            
    func performSave(movie: MyMovie) -> CocoaAction {
        return Action { input in
            self.storage.save(movie: movie)
            return Observable.empty()
        }
    }
    
    func performDelete(movie: MyMovie) -> CocoaAction {
        return Action { input in
            self.storage.delete(movie: movie)
            return Observable.empty()
        }
    }
    
    //영화 ID값을 비교해서 CoreData에 있으면 true, 없으면 false를 반환
    //true이면 삭제버튼이 되도록, false이면 저장 버튼이 되도록 처리하기 위한 목적
    func checkMovieInStorage(movie: MyMovie) -> Observable<Bool> {
        return self.storage.compare(movie: movie)
    }
}
