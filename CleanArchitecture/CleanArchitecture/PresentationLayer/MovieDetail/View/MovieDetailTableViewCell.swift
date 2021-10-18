//
//  MovieDetailTableViewCell.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/27.
//

import UIKit
import Kingfisher

class MovieDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    
    lazy var processor = DownsamplingImageProcessor(size: self.imageMovie.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 20)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageMovie.kf.indicatorType = .activity
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
        imageMovie.kf.setImage(with: url, options: [
            .cacheSerializer(FormatIndicatedCacheSerializer.png),
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
    }
}
