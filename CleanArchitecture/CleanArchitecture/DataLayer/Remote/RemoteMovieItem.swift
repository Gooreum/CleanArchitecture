//
//  MovieItem.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import CoreData
import RxCoreData
import RxDataSources

struct RemoteMovieItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
    let id: Int
    let title: String
    let posterPath: String
    let overview: String
    let releaseDate: String
}

//MARK: CoreData object model
struct Movie: Decodable {
    let id: Int
    let overview: String
    let release_date: String
    let title: String
    var poster_path: String? = ""
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
        poster_path = entity.value(forKey: "poster_path") as? String
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(release_date, forKey: "release_date")
        entity.setValue(overview, forKey: "overview")
        entity.setValue(title, forKey: "title")
        entity.setValue(poster_path, forKey: "poster_path")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
}
