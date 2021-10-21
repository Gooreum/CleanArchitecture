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

enum CoreDataError: Error {
    case fetchingFail
    case saveFail
    case checkFail
    case deleteFail
}

class MyMovieStorageImpl: MyMovieStorageable {
    let localMyMoviesMapper = LocalMyMoviesMapper()
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //return
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
    func save(movie: MovieDetailEntity) -> Completable {
        do {
            let movieItem = localMyMoviesMapper.myMoviesItemToLocalMyMoviesItem(movieDetailItem: movie)
            _ = try mainContext.rx.update(movieItem)
            print("Movie has been saved : returns true")
            return Completable.empty()
        }catch {
            print("Movie has not been saved")
            return Completable.error(error)
        }
    }
    
    @discardableResult
    func fetchMyMovieList() -> Single<[MyMoviesEntity]> {
        return Single.create { [weak self] emitter in
            do {
                let fetchRequest = NSFetchRequest<LocalMyMoviesItem.T>(entityName: "Movie")
                let result = try self?.mainContext.fetch(fetchRequest)
                let localMyMoviesItem = result.map {$0.map(LocalMyMoviesItem.init)}
                emitter(.success((self?.localMyMoviesMapper.localMyMoviesItemToMyMoviesItem(localMoviesItem: localMyMoviesItem!))!))
            } catch {
                print("Could not fetch \(error) ")
                emitter(.failure(CoreDataError.fetchingFail))
            }
            return Disposables.create()
        }
        //, sortDescriptors: [NSSortDescriptor(key: "release_date", ascending: false)]
        //return mainContext.rx.entities(Movie.self)
    }
    
    @discardableResult
    func checkMovieInStore(movie: MovieDetailEntity) -> Observable<Bool> {
        let movieItem = localMyMoviesMapper.myMoviesItemToLocalMyMoviesItem(movieDetailItem: movie)
        let fetchRequest: NSFetchRequest<MovieEntity>
        fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id LIKE %@", "\(movieItem.identity)")
        
        do {
            let objects = try mainContext.fetch(fetchRequest)
            switch objects.isEmpty {
            case true :
                print("Movie is not in storage : returns false")
                return Observable.of(false)
            case false :
                print("Movie is in storage : returns true")
                return Observable.of(true)
            }
        }catch {
            return Observable.error(error)
        }
    }
    
    //save -> 로컬DB있으니까 true 던져주고
    //delete -> 로컬DB에 없으니까 false던져줌.
    
    @discardableResult
    func delete(movie: MovieDetailEntity) -> Completable {
        do {
            let movieItem = localMyMoviesMapper.myMoviesItemToLocalMyMoviesItem(movieDetailItem: movie)
            try mainContext.rx.delete(movieItem)
            print("Movie has been deleted : returns true")
            return Completable.empty()
        } catch {
            print("Deleting movie has an error..")
            return Completable.error(CoreDataError.deleteFail)
        }
    }
}
