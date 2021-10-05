//
//  MyMovie.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/29.
//

import Foundation
import CoreData
import RxCoreData
import RxDataSources

struct MoviePlayingResponse: Decodable {
    let page: Int
    let dates: [String: String]
    let results: [Movie]
}

struct MovieResponse: Decodable {
    let movie: [Movie]
}

//MARK: CoreData object model
struct Movie: Decodable {
    let id: Int
    let overview: String
    let release_date: String
    let title: String
        
    init(id: Int, title: String, releaseDate: String, overview: String){
        self.id = id
        self.title = title
        self.release_date = releaseDate
        self.overview = overview
    }
}

extension Movie : Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Movie : IdentifiableType {
    typealias Identity = String
   
    var identity: Identity { return "\(id)" }
}

extension Movie : Persistable {
    
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "Movie"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! Int
        release_date = entity.value(forKey: "release_date") as! String
        overview = entity.value(forKey: "overview") as! String
        title = entity.value(forKey: "title") as! String
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(release_date, forKey: "release_date")
        entity.setValue(overview, forKey: "overview")
        entity.setValue(title, forKey: "title")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
}