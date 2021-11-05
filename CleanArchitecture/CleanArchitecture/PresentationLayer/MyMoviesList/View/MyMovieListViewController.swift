//
//  MyMovieListViewController.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/29.
//


import UIKit
import RxSwift
import RxCocoa

class MyMovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MyMovieListViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchMyMoveList()
    }
    
    func setUpBindings() {        

        viewModel?.myMoveListSubject
            .debug("[MyMovieListViewController] viewModel?.myMovieListSubject --- ")
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: MoviesPlayingTableViewCell.self)) { [weak self] (_, movie, cell) in
                self?.setupCell(cell, movie: movie)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MyMoviesResponseModel.self)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
                let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! MovieDetailViewController
               // movieDetailVC.movie = $0
                //self.navigationController?.pushViewController(movieDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCell(_ cell: MoviesPlayingTableViewCell, movie: MyMoviesResponseModel) {
        cell.selectionStyle = .none
        cell.setTitle(movie.title)
        cell.setOverview(movie.overview)        
        cell.setReleaseDate(movie.releaseDate)
        cell.setImage(composeMovieImageUrlRequest(posterPath: movie.posterPath))
    }
}

