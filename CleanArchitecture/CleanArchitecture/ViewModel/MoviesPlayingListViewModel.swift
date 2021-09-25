//
//  MoviesPlayingListViewModel.swift.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/25.
//

import Foundation
import RxSwift

enum error: String,Error {
    case noValue = "값 없음"
}

public class MoviesPlayingListViewModel {
    
    private let webService = WebService()
    
    var moviesPlayingList: Observable<[Movie]> {
        return webService.fetchMoviesPlaying()
    }
}
