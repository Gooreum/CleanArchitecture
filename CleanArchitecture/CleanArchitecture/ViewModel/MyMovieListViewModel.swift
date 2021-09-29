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
    
    let storage: CoreDataStorage
    
    init() {
        self.storage = CoreDataStorage(modelName: "Model")
    }
    
    var myMovieList: Observable<[MyMovie]> {
        self.storage.myMovieList()
    }
}

