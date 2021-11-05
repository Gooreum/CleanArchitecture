//
//  MyMoviesMapper.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/21.
//

import Foundation

struct MyMoviesMapper : GetDataMapperable {
    func entityToRsponseModel(entity: [MyMoviesEntity]) -> [MyMoviesResponseModel] {
        var myMoviesResponseModel: [MyMoviesResponseModel] = []
        entity.forEach { element in
            myMoviesResponseModel.append(MyMoviesResponseModel(id: element.id, title: element.title, posterPath: element.posterPath, overview: element.overview, releaseDate: element.releaseDate) )
        }
        return myMoviesResponseModel
    }
}
