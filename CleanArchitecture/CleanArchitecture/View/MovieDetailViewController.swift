//
//  MovieDetailViewController.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/27.
//


import UIKit
import RxSwift
import RxCocoa
import CoreData

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    private var viewModel = MovieViewModel()
    var movie: MyMovie?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
    }
    
    private func setUpBinding() {
        if let id = self.movie?.id {
            viewModel.convertMovieDataAsStream(id: id)
                .bind(to: tableView.rx.items(cellIdentifier: "MovieDetailCell", cellType: MovieDetailTableViewCell.self)) { [weak self] (_, movie, cell) in
                    self?.setupCell(cell, movie: movie)
                }
                .disposed(by: disposeBag)
        }else {
            print("No ID")
        }
        
        if let movie = self.movie {
            viewModel.checkMovieInStorage(movie: movie)
                .subscribe(onNext: {
                    switch $0 {
                    case true :
                        print("TRUE")
                        self.btnSave.rx.action = self.viewModel.performSave(movie: movie)
                        self.btnSave.title = "저장"
                    case false :
                        print("FALSE")
                        self.btnSave.rx.action = self.viewModel.performDelete(movie: movie)
                        self.btnSave.title = "삭제"
                    }
                })
                .disposed(by: disposeBag)
            
            
        }
    }
    
    private func setupCell(_ cell: MovieDetailTableViewCell, movie: MyMovie) {
        cell.selectionStyle = .none
        cell.setTitle(movie.title ?? "")
        cell.setOverview(movie.overview ?? "")
        cell.setReleaseDate(movie.release_date ?? "")
        cell.setRevenue("\(movie.revenue ?? 0)")
        cell.setGeneres(movie.genres?[0].name ?? "")
        cell.setRuntime("\(movie.runtime ?? 0)")
        cell.setVoteAverage("\(movie.vote_average ?? 0)")
    }
}

