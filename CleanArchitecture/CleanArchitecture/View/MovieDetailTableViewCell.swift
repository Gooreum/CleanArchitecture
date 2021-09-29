//
//  MovieDetailTableViewCell.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/27.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelrevenue: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    @IBOutlet weak var labelVoteAverage: UILabel!
    @IBOutlet weak var labelRuntime: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    
    func setTitle(_ title: String) {
        labelTitle.text = title
    }
    
    func setReleaseDate(_ releaseDate: String) {
        labelReleaseDate.text = releaseDate
    }
    
    func setRevenue(_ revenue: String) {
        labelrevenue.text = revenue
    }
    
    func setGeneres(_ genre: String) {
        labelGenres.text = genre
    }
    
    func setVoteAverage(_ voteAverage: String) {
        labelVoteAverage.text = voteAverage
    }
    
    func setRuntime(_ runtime: String) {
        labelRuntime.text = runtime
    }
    
    func setOverview(_ overview: String) {
        labelOverview.text = overview
    }
    
}
