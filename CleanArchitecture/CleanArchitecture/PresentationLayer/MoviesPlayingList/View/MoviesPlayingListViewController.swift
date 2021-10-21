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
    private var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        setUpBindings()
        setActivityIndicatorView()
    }
    
    func setUpBindings() {
        //새로고침
        tableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .do(onNext: {[weak self] in self?.page = 1})
            .debug("<<<<<<<tableView.refreshControl?.rx>>>>>>> : ")
            .map{ self.page }
            .startWith(self.page)
            .do(onNext: { [weak self] _ in
                if self?.viewModel!.networkStateUtil.monitorReachability() == false {
                    let myMovieListVC = self?.storyboard?.instantiateViewController(withIdentifier: "MyMovieListVC") as! MyMovieListViewController
                    self?.navigationController?.modalPresentationStyle = .pageSheet
                    self?.navigationController?.present(myMovieListVC, animated: true)                    
                }})
            .bind(to: viewModel!.fetch)
            .disposed(by: disposeBag)
                
        viewModel?.refreshActivated
            .debug("<<<<<<<viewModel?.refreshActivated>>>>>>>")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        //페이징
        viewModel?.paginationActivated
            .debug("<<<<<<<viewModel?.paginationActivated>>>>>>>")
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.tableView.tableFooterView?.isHidden = $0
            })
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom()
            .debug("<<<<<<<tableView.rx.reachedBottom()>>>>>>>")
            .do(onNext: { [weak self] in
                self?.viewModel!.networkStateUtil.monitorReachability() == true ? self?.page += 1 : ()})
            .map { self.page }
            .bind(to: viewModel!.fetch)
            .disposed(by: disposeBag)
        
        //테이블뷰 데이터 바인딩
        viewModel?.moviesRelay
            .debug("<<<<<<<viewModel?.moviesRelay>>>>>>>")
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: MoviesPlayingTableViewCell.self)) { [weak self] (_, movie, cell) in
                self?.setupCell(cell, movie: movie)
            }
            .disposed(by: disposeBag)
        
        //테이블뷰 클릭 이벤트
        tableView.rx.modelSelected(MoviesPlayingResponseModel.self)
            .debug("<<<<<<<tableView.rx.modelSelected(Movie.self)>>>>>>>")
            .subscribe(onNext: { [weak self] in
                print("-------------------\($0)")
                let movieDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! MovieDetailViewController
                //movieDetailVC.movie = $0
                movieDetailVC.id = $0.id
                
                self?.navigationController?.pushViewController(movieDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCell(_ cell: MoviesPlayingTableViewCell, movie: MoviesPlayingResponseModel) {
        cell.selectionStyle = .none
        cell.setTitle(movie.title ?? "")
        cell.setOverview(movie.overview ?? "")
        cell.setReleaseDate(movie.releaseDate ?? "")
        cell.setImage(composeMovieImageUrlRequest(posterPath: movie.posterPath ?? ""))
    }
    
    private func setActivityIndicatorView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        tableView.tableFooterView = footerView
        tableView.tableFooterView?.isHidden = true
    }
}

