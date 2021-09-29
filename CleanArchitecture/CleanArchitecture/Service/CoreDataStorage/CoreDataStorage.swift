//
//  CoreDataStorage.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/28.
//

import Foundation
import RxCoreData
import RxSwift
import CoreData


class CoreDataStorage: MovieStorageType {
           
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //Main Context 속성 추가
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    @discardableResult
    func save(movie: MyMovie) -> Observable<MyMovie> {
        do {
            _ = try mainContext.rx.update(movie)
            return Observable.just(movie)
        }catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func myMovieList() -> Observable<[MyMovie]> {
        return mainContext.rx.entities(MyMovie.self, sortDescriptors: [NSSortDescriptor(key: "release_date", ascending: false)])
    }
    
    @discardableResult
    func compare(movie: MyMovie) -> Observable<Bool> {
        
        let fetchRequest: NSFetchRequest<MyMovieEntity>
        fetchRequest = MyMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id LIKE %@", "\(movie.identity)")
        
        do {
            let objects = try mainContext.fetch(fetchRequest)
            switch objects.isEmpty {
            case true :                
                return Observable.just(true)
            case false :
                return Observable.just(false)
            }
        }catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func delete(movie: MyMovie) -> Observable<MyMovie> {
        do {
            try mainContext.rx.delete(movie)
            return Observable.just(movie)
        } catch {
            return Observable.error(error)
        }
    }
}
