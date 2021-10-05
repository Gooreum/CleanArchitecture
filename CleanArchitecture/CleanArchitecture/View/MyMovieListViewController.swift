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
    
    func setUpBindings() {        
        viewModel?.myMovieList
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: MoviesPlayingTableViewCell.self)) { [weak self] (_, movie, cell) in
                self?.setupCell(cell, movie: movie)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: {
                let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! MovieDetailViewController
                movieDetailVC.movie = $0 as? Movie
                self.navigationController?.pushViewController(movieDetailVC, animated: true)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCell(_ cell: MoviesPlayingTableViewCell, movie: Movie) {
        cell.selectionStyle = .none
        cell.setTitle(movie.title)
        cell.setOverview(movie.overview)        
        cell.setReleaseDate(movie.release_date)
       
    }
}

