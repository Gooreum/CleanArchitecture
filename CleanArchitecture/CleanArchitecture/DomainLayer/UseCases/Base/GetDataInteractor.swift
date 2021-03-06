//
//  GetDataInteractor.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/19.
//

import Foundation
import RxSwift

protocol GetDataInteractorable {
    associatedtype RQM: GetDataRequestModelable
    associatedtype RPM: GetDataResponseModelable
    
    func getData(requestModel: RQM) -> Single<RPM>
}
