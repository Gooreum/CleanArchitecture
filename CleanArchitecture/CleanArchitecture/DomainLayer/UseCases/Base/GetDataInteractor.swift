//
//  GetDataInteractor.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import RxSwift

protocol GetDataInteractor {
    associatedtype RQM: GetDataRequestModel
    associatedtype RPM: GetDataResponseModel
    
    func getData(requestModel: RQM) -> Single<RPM>
}
