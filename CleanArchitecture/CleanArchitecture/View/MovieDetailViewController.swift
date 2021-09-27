//
//  MovieDetailViewController.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/27.
//


import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var viewModel = MovieViewModel()
    var id: Int?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
    }
    
    private func setUpBinding() {
        if let id = self.id {
            viewModel.convertMovieDataAsStream(id: id)
                .bind(to: tableView.rx.items(cellIdentifier: "MovieDetailCell", cellType: MovieDetailTableViewCell.self)) { [weak self] (_, movie, cell) in
                    self?.setupCell(cell, movie: movie)
                }
                .disposed(by: disposeBag)
        }else {            
            print("No ID")
        }
    }
    
    private func setupCell(_ cell: MovieDetailTableViewCell, movie: Movie) {
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

