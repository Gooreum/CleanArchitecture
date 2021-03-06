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
    var movie: MoviesPlayingResponseModel?    
    var viewModel: MovieViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
    }
    
    private func setUpBinding() {
        guard let movie = self.movie, let movieDetail = viewModel?.moviesPlayingResponseModelToMovieDetailRequestModel(responseModel: movie) else {
            return
        }
        
        //로컬DB에 상세보기 영화가 있는지 확인
        viewModel?.checkMovieInStorage(movie: movieDetail)
        //저장 및 삭제 버튼 enable 처리
        viewModel?.buttonEnabled
            .subscribe(onNext: { [weak self] in
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
        viewModel?.fetchMovieDetail(id: movieDetail.id)
        
        //TableView에 데이터에 바인딩 해주기
        viewModel?.movieSubject
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "MovieDetailCell", cellType: MovieDetailTableViewCell.self)) { (_, movie, cell) in
                self.setupCell(cell, movie: movie)
            }
            .disposed(by: disposeBag)
        
        btnDelete.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in self?.viewModel?.deleteMovie(movie: movieDetail) })
            .disposed(by: disposeBag)
        
        btnSave.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in self?.viewModel?.saveMovie(movie: movieDetail) })
            .disposed(by: disposeBag)
    }
    
    private func setupCell(_ cell: MovieDetailTableViewCell, movie: MovieDetailResponseModel) {
        cell.selectionStyle = .none
        cell.setTitle(movie.title ?? "")
        cell.setOverview(movie.overview ?? "")
        cell.setReleaseDate(movie.releaseDate ?? "")
        cell.setImage(composeMovieImageUrlRequest(posterPath: movie.posterPath ?? ""))
    }
}

