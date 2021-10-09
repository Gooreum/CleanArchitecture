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
        //setActivityIndicatorView()
    }
    
    func setUpBindings() {
        //새로고침
        tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .debug()
            .startWith(())
            .bind(to: viewModel!.refreshfetching)
            .disposed(by: disposeBag)
                
        viewModel?.refreshActivated
            .debug()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        //페이징
        viewModel?.paginationActivated
            .debug()
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setActivityIndicatorView().isHidden = $0
            })
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom()
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel!.paginationfetching)
            .disposed(by: disposeBag)
        
        //테이블뷰 데이터 바인딩
        viewModel?.moviesRelay
            .debug()
            .catchAndReturn([Movie]())
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
        cell.setImage(composeMovieImageUrlRequest(posterPath: movie.poster_path ?? ""), cacheKey: "\(movie.id)")
    }
    
    private func setActivityIndicatorView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        tableView.tableFooterView = footerView
        return footerView
    }
    
}

