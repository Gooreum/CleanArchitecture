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



struct MovieResponse:Codable {
    let page: Int
    let dates: [String: String]
    let results: [MyMovie]
}



struct MyMovie: Codable {
//    var id: String
//    var release_date: String
//    var overview: String
//    var title: String
    var id: Int? = 0
    var overview: String? = ""
    var release_date: String? = ""
    var title: String? = ""
    var poster_path: String? = ""
    var revenue: Int? = 0
    var runtime: Int? = 0    
    var vote_average: Double? = 0.0
    var genres: [Genres]? = []
    
    struct Genres: Codable {
        var id: Int? = 0
        var name: String? = ""
    }
    
    init(id: Int, title: String, releaseDate: String, overview: String){
        self.id = id
        self.title = title
        self.release_date = releaseDate
        self.overview = overview
    }
}

extension MyMovie : Equatable {
    static func == (lhs: MyMovie, rhs: MyMovie) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MyMovie : IdentifiableType {
    typealias Identity = String
   
    var identity: Identity { return "\(id ?? 0)" }
}

extension MyMovie : Persistable {
    
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "MyMovie"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as? Int
        release_date = entity.value(forKey: "release_date") as? String
        overview = entity.value(forKey: "overview") as? String
        title = entity.value(forKey: "title") as? String
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(release_date, forKey: "release_date")
        entity.setValue(overview, forKey: "overview")
        entity.setValue(title, forKey: "title")
        //entity.setValue(identity, forKey: "identity")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
}
