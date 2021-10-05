//
//  MovieStorageImpl.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/28.
//

import Foundation
import RxCoreData
import RxSwift
import CoreData


class MovieStorageImpl: MovieStorageType {
           
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
    func save(movie: Movie) -> Completable {
        do {
            _ = try mainContext.rx.update(movie)
            return Completable.empty()
        }catch {
            return Completable.error(error)
        }
    }
    
    @discardableResult
    func myMovieList() -> Observable<[Movie]> {
        return mainContext.rx.entities(Movie.self, sortDescriptors: [NSSortDescriptor(key: "release_date", ascending: false)])
    }
    
    @discardableResult
    func compare(movie: Movie) -> Observable<Bool> {
        
        let fetchRequest: NSFetchRequest<MovieEntity>
        fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id LIKE %@", "\(movie.identity)")
        
        do {
            let objects = try mainContext.fetch(fetchRequest)
            switch objects.isEmpty {
            case true :                
                return Observable.just(false)
            case false :
                return Observable.just(true)
            }
        }catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func delete(movie: Movie) -> Completable {
        do {
            try mainContext.rx.delete(movie)
            return Completable.empty()
        } catch {
            return Completable.error(error)
        }
    }
}
