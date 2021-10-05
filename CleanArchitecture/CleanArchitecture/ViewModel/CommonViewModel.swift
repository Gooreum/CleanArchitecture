//
//  CommonViewModel.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/27.
//

import Foundation
import RxSwift
import RxCocoa


protocol CommonViewModel {    
    var webService: WebServiceType? {get}
    var storage: MovieStorageType? {get}
}

