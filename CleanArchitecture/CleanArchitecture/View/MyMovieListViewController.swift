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
        
        //영화상세에서 로컬에 저장된 영화 삭제가 되면 새롭게 myMovieList를 불러오고 싶은데.. 어떻게 해야될지 모르겠음..
        viewModel?.fetchMyMoveList()
    }
    
    func setUpBindings() {        

        viewModel?.myMoveListSubject
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: MoviesPlayingTableViewCell.self)) { [weak self] (_, movie, cell) in
                self?.setupCell(cell, movie: movie)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observe(on: MainScheduler.instance)
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

