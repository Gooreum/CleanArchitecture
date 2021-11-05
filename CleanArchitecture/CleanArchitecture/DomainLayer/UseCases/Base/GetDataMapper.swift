//
//  GetDataMapper.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import RxSwift

protocol GetDataMapperable {
    associatedtype Entity
    associatedtype ResponseModel
    func entityToRsponseModel(entity: Entity) -> [ResponseModel]
}
