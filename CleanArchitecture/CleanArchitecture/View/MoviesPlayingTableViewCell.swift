//
//  MovesPlayingTableViewCell.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/25.
//

import UIKit

class MoviesPlayingTableViewCell: UITableViewCell {
    
    //@IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    
    func setTitle(_ title: String) {
        labelTitle.text = title
    }
    
    func setReleaseDate(_ releaseDate: String) {
        labelReleaseDate.text = releaseDate
    }
    
    func setOverview(_ overview: String) {
        labelOverview.text = overview
    }
}