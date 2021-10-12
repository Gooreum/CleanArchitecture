//
//  NetworkState.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/10/07.
//

import Foundation
import Alamofire

class NetworkState {
    private var reachability: NetworkReachabilityManager!
    
    init() {
        reachability = NetworkReachabilityManager.default
    }
    
    func monitorReachability() -> Bool{
        return  reachability.isReachable        
    }
}
