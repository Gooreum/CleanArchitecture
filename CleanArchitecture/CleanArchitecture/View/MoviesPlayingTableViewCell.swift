//
//  MovesPlayingTableViewCell.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/25.
//

import UIKit
import AlamofireImage

class MoviesPlayingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let imageCache = AutoPurgingImageCache()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTitle(_ title: String) {
        labelTitle.text = title
    }
    
    func setReleaseDate(_ releaseDate: String) {
        labelReleaseDate.text = releaseDate
    }
    
    func setOverview(_ overview: String) {
        labelOverview.text = overview
    }
    
    func setImage(_ url: URL) {
        imageMovie.af.setImage(withURL: url, placeholderImage: UIImage(named: "squidgame"),completion:  { [weak self] _ in
            self?.activityIndicator.stopAnimating()
        })
    }
}
