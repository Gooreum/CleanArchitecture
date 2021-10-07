//
//  AppDelegate.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/24.
//

import UIKit
import Swinject
import SwinjectStoryboard
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var container: Container = {
        let container = Container()
        
        container.register(WebServiceType.self) { _ in WebServiceImpl() }
        container.register(NetworkState.self) { _ in NetworkState() }
        container.register(MovieStorageType.self) { _ in MovieStorageImpl(modelName: "Model") }
        
        container.register(MoviesPlayingListViewModel.self, name: "MoviesPlayingListViewModel") { r in
            let viewModel = MoviesPlayingListViewModel(webService: r.resolve(WebServiceType.self)!, storage: r.resolve(MovieStorageType.self)!, networkStateUtil: r.resolve(NetworkState.self)!)
            return viewModel
        }
        
        container.register(MovieViewModel.self, name: "MovieViewModel") { r in
            let viewModel = MovieViewModel(webService: r.resolve(WebServiceType.self)!, storage: r.resolve(MovieStorageType.self)!)
            return viewModel
        }
        
        container.register(MyMovieListViewModel.self, name: "MyMovieListViewModel") { r in
            let viewModel = MyMovieListViewModel(webService: r.resolve(WebServiceType.self)!, storage: r.resolve(MovieStorageType.self)!)
            return viewModel
        }
                
        container.storyboardInitCompleted(MoviesPlayingListViewController.self) { r, c in
            c.viewModel = r.resolve(MoviesPlayingListViewModel.self, name: "MoviesPlayingListViewModel")
        }
        
        container.storyboardInitCompleted(MovieDetailViewController.self) { r, c in
            c.viewModel = r.resolve(MovieViewModel.self, name: "MovieViewModel")
        }
        
        container.storyboardInitCompleted(MyMovieListViewController.self) { r, c in
            c.viewModel = r.resolve(MyMovieListViewModel.self, name: "MyMovieListViewModel")
            
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        
        return true
    }
}

