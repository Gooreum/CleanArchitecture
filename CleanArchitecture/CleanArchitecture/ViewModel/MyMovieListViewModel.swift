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
    var storage: MovieStorageType?
    
    
    var myMovieList: Observable<[Movie]> {
        if let storage = self.storage {
            return storage.myMovieList()
        }else {
            fatalError()
        }
    }
}

