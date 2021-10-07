//
//  MoviesPlayingListViewController.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/24.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesPlayingListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: MoviesPlayingListViewModel?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        setUpBindings()
    }
    
    func setUpBindings() {
                
        let reload = tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () } ?? Observable.just(())
        
        Observable.merge(reload)
            .bind(to: viewModel!.fetchMovies)
            .disposed(by: disposeBag)
        
        viewModel?.moviesSubject
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: MoviesPlayingTableViewCell.self)) { [weak self] (_, movie, cell) in
                self?.setupCell(cell, movie: movie)
            }
            .disposed(by: disposeBag)
        
        
        viewModel?.activated
            //.map{ !$0 }
            .debug()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { finished in                
                self.tableView.refreshControl?.endRefreshing()
                
            })
                
        
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: {
                let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! MovieDetailViewController               
                movieDetailVC.movie = $0
                self.navigationController?.pushViewController(movieDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCell(_ cell: MoviesPlayingTableViewCell, movie: Movie) {
        cell.selectionStyle = .none
        cell.setTitle(movie.title)
        cell.setOverview(movie.overview)
        cell.setReleaseDate(movie.release_date)
        cell.setImage(composeMovieImageUrlRequest(posterPath: movie.poster_path ?? ""))
    }
}

