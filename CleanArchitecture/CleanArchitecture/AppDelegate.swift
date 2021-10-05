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
        container.register(MovieStorageType.self) { _ in MovieStorageImpl(modelName: "Model") }
        
        //ViewModel
        container.register(CommonViewModel.self, name: "MoviesPlayingListViewModel") { r in
            let viewModel = MoviesPlayingListViewModel()            
            viewModel.webService = r.resolve(WebServiceType.self)
            viewModel.storage = r.resolve(MovieStorageType.self)
            return viewModel
        }
        container.register(CommonViewModel.self, name: "MovieViewModel") { r in
            let viewModel = MovieViewModel()
            viewModel.webService = r.resolve(WebServiceType.self)
            viewModel.storage = r.resolve(MovieStorageType.self)
            return viewModel
        }
        
        container.register(CommonViewModel.self, name: "MyMovieListViewModel") { r in
            let viewModel = MyMovieListViewModel()
            viewModel.webService = r.resolve(WebServiceType.self)
            viewModel.storage = r.resolve(MovieStorageType.self)
            return viewModel
        }
                
        container.storyboardInitCompleted(MoviesPlayingListViewController.self) { r, c in
            c.viewModel = r.resolve(CommonViewModel.self, name: "MoviesPlayingListViewModel") as! MoviesPlayingListViewModel
        }
        
        container.storyboardInitCompleted(MovieDetailViewController.self) { r, c in
            c.viewModel = r.resolve(CommonViewModel.self, name: "MovieViewModel") as? MovieViewModel
        }
        
        container.storyboardInitCompleted(MyMovieListViewController.self) { r, c in
            c.viewModel = r.resolve(CommonViewModel.self, name: "MyMovieListViewModel") as? MyMovieListViewModel
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        
        return true
    }
}

