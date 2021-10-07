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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    var viewModel: MoviesPlayingListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        setUpBindings()
    }
    
    func setUpBindings() {
        //새로고침
        tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .debug()
            .startWith(())
            .bind(to: viewModel!.refreshingfetching)
            .disposed(by: disposeBag)
                
        viewModel?.refreshingActivated
            .debug()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { finished in
                self.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        //페이징
        viewModel?.paginationActivated
            .debug()
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .bind(to: self.activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom()
            .debug()
            .skip(1)
            .bind(to: viewModel!.paginationfetching)
            .disposed(by: disposeBag)
        
        //테이블뷰 데이터 바인딩
        viewModel?.moviesSubject
            .debug()
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: MoviesPlayingTableViewCell.self)) { [weak self] (_, movie, cell) in
                self?.setupCell(cell, movie: movie)
            }
            .disposed(by: disposeBag)
        
        //테이블뷰 클릭 이벤트
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

