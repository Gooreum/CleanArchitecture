//
//  LocalMyMoviesItem.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/22.
//

import Foundation
import CoreData
import RxCoreData
import RxDataSources

//MARK: CoreData object model
struct LocalMyMoviesItem: Decodable {
    let id: Int
    let overview: String
    let releaseDate: String
    let title: String
    let posterPath: String
}

extension LocalMyMoviesItem : Equatable {
    static func == (lhs: LocalMyMoviesItem, rhs: LocalMyMoviesItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension LocalMyMoviesItem : IdentifiableType {
    typealias Identity = String
    var identity: Identity { return "\(id)" }
}

extension LocalMyMoviesItem : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "Movie"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! Int
        releaseDate = entity.value(forKey: "releaseDate") as! String
        overview = entity.value(forKey: "overview") as! String
        title = entity.value(forKey: "title") as! String
        posterPath = entity.value(forKey: "posterPath") as! String
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(releaseDate, forKey: "releaseDate")
        entity.setValue(overview, forKey: "overview")
        entity.setValue(title, forKey: "title")
        entity.setValue(posterPath, forKey: "posterPath")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
}
