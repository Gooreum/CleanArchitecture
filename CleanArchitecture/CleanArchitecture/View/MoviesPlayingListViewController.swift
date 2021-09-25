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
    
    private let viewModel = MoviesPlayingListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMovesPlayingList()
    }
    
    private func setMovesPlayingList() {
        viewModel.moviesPlayingList
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { (index, movies, cell) in
                guard let cell = cell as? MoviesPlayingTableViewCell else {
                    return
                }
                cell.labelOverview.text = movies.overview
                cell.labelReleaseDate.text = movies.release_date
                cell.labelTitle.text = movies.title
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: {
                print($0)
                print($0.id)
            })
            .disposed(by: disposeBag)
            
    }
}

