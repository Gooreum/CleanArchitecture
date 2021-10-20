//
//  AppDelegate.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/24.
//

import UIKit
import Swinject
import SwinjectStoryboard
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let imageCache: ImageCache = ImageCache.default
    var container: Container = {
        let container = Container()
        
        container.register(WebServiceType.self) { _ in WebServiceImpl() }
        container.register(NetworkState.self) { _ in NetworkState() }
        container.register(MovieStorageType.self) { _ in MovieStorageImpl(modelName: "Model") }
        
        container.register(MovieRepositoriable.self, name: "MovieRepository") { r in
            let movieRepositoryImp = MovieRepositoryImpl(webService: r.resolve(WebServiceType.self)!, storage: r.resolve(MovieStorageType.self)!, networkStateUtil: r.resolve(NetworkState.self)!)
            return movieRepositoryImp
        }
        
        container.register(MovieDetailUseCase.self, name: "MovieDetailUseCase") { r in
            let usecaseImpl = MovieDetailUseCaseImpl(movieRepository: r.resolve(MovieRepositoriable.self, name:"MovieRepository")!)
            return usecaseImpl
        }
        
        container.register(MoviesPlayingListViewModel.self, name: "MoviesPlayingListViewModel") { r in
            let viewModel = MoviesPlayingListViewModel(webService: r.resolve(WebServiceType.self)!, storage: r.resolve(MovieStorageType.self)!, networkStateUtil: r.resolve(NetworkState.self)!)
            return viewModel
        }
        
        container.register(MovieViewModel.self, name: "MovieViewModel") { r in
            let viewModel = MovieViewModel(movieDetailUseCase: r.resolve(MovieDetailUseCase.self, name:"MovieDetailUseCase")!)
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
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //이미지 캐시크기 가져오기
        getImageCacheSize()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //앱 종료시 이미지 캐시 삭제
        removeImageCache()
    }
}

//MARK: 기능추가
extension AppDelegate {
    private func removeImageCache() {
        // Remove all.
        imageCache.clearMemoryCache()
        imageCache.clearDiskCache { print("Done") }
        
        //Remove ExpiredMemory Cache.
        imageCache.cleanExpiredMemoryCache()
        imageCache.cleanExpiredDiskCache { print("Done") }
    }
    
    private func getImageCacheSize() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                print("Disk cache size: \(Double(size) / 1024 / 1024) MB")
            case .failure(let error):
                print(error)
            }
        }
    }
}

