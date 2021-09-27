//
//  Movie.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/24.
//

import RxCoreData
import CoreData
import RxSwift

struct Movie: Codable {
    var id: Int? = 0
    var overview: String? = ""
    var poster_path: String? = ""
    var release_date: String? = ""
    var revenue: Int? = 0
    var runtime: Int? = 0
    var title: String? = ""
    var vote_average: Double? = 0.0
    var genres: [Genres]? = []
    
    struct Genres: Codable {
        var id: Int? = 0
        var name: String? = ""
    }
}

struct MovieResponse:Codable {
    let page: Int
    let dates: [String: String]
    let results: [Movie]
}

//아직 coredata는 잘 모르겠다..
//extension Movie: Persistable {
//    var identity: String {
//        return "id"
//    }
//
//    public static var entityName: String {
//        return "Movie"
//    }
//
//    static var primaryAttributeName: String {
//        return "id"
//    }
//
//    //인스턴스 초기화 하는 생성자
//    init( entity: NSManagedObject) {
//        id = entity.value(forKey: "id") as? Int
//        title = entity.value(forKey: "title") as? String
//        overview = entity.value(forKey: "overview") as? String
//        release_date = entity.value(forKey: "release_date") as? String
//    }
//
//    func update(_ entity: NSManagedObject) {
//        entity.setValue(id, forKey: "id")
//        entity.setValue(title, forKey: "title")
//        entity.setValue(overview, forKey: "overview")
//        entity.setValue(release_date, forKey: "release_date")
//
//        do {
//            //CoreData를 RxCoreData로 구현할 시 주의해야 할 점 :
//            //RxCoreData는 context를 알아서 저장해주기 때문에 save를 직접 호출할 필요가 없음, 그런데 지금 구현하고 있는 이 코드는 RxCoreData를 사용하고 있지 않음. 그래서 Save 메서드를 직접 호출해야 한다. 그렇지 않으면 경우에 따라서 update한 내용이 사라질 수 있다.
//            try entity.managedObjectContext?.save()
//        } catch  {
//            print(error)
//        }
//    }
//}
