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
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    var viewModel: MovieViewModel?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
    }
    
    private func setUpBinding() {
        guard let movie = self.movie else {
            return
        }
        
        //로컬DB에 상세보기 영화가 있는지 확인
        viewModel?.checkMovieInStorage(movie: movie)
        
        //저장 및 삭제 버튼 enable 처리
        viewModel?.buttonEnabled
            .subscribe(onNext: { [weak self] in
                print($0)
                switch $0 {
                case true:
                    self?.btnSave.isEnabled = false
                    self?.btnDelete.isEnabled = true
                case false:
                    self?.btnSave.isEnabled = true
                    self?.btnDelete.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        //영화 가져오기
        viewModel?.fetchMovieDetail(id: movie.id)
        
        //TableView에 데이터에 바인딩 해주기
        viewModel?.movieSubject
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "MovieDetailCell", cellType: MovieDetailTableViewCell.self)) { (_, movie, cell) in
                self.setupCell(cell, movie: movie)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setupCell(_ cell: MovieDetailTableViewCell, movie: Movie) {
        cell.selectionStyle = .none
        cell.setTitle(movie.title)
        cell.setOverview(movie.overview)
        cell.setReleaseDate(movie.release_date)
        cell.setImage(composeMovieImageUrlRequest(posterPath: movie.poster_path ?? ""))
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        if let movie = self.movie {
            viewModel?.deleteMovie(movie: movie)
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if let movie = self.movie {
            viewModel?.saveMovie(movie: movie)
        }
    }
}

