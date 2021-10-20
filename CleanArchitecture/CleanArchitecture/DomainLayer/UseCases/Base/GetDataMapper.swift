//
//  GetDataMapper.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import RxSwift

protocol GetDataMapper {
    typealias E = MovieDetailEntity
    typealias RPM = MovieDetailResponseModel
    func entityTorRsponseModel(entity: [E]) -> [RPM]
}
