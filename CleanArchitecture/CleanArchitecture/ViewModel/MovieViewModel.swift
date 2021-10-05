//
//  MovieViewModel.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/26.
//

import Foundation
import RxSwift
import Action

class MovieViewModel: CommonViewModel {
    
    private let disposeBag = DisposeBag()
    var webService: WebServiceType?
    var storage: MovieStorageType?
        
    //영화 상세정보 가져오기
    func movieDetail(id: Int) -> Observable<[Movie]>{
        return Observable.create { observer in
            self.webService?.fetchMovieDetail(id: id) { (movie, error) in
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
    
    //영화 저장
    func performSave(movie: Movie) -> CocoaAction {
        return Action { input in
            self.storage?.save(movie: movie)
            return Observable.empty()
        }
    }
    
    //영화 삭제
    func performDelete(movie: Movie) -> CocoaAction {
        return Action { input in
            self.storage?.delete(movie: movie)
            return Observable.empty()
        }
    }
    
    //영화 ID값을 비교해서 CoreData에 있으면 true, 없으면 false를 반환
    //true이면 삭제버튼이 되도록, false이면 저장 버튼이 되도록 처리하기 위한 목적
    func checkMovieInStorage(movie: Movie) -> Observable<Bool> {
        if let storage = self.storage {
            return storage.compare(movie: movie)
        }else {
            fatalError()
        }
    }
}
