//
//  MovesPlayingTableViewCell.swift
//  CleanArchitecture
//
//  Created by Mingu Seo on 2021/09/25.
//

import Foundation
import UIKit

class MoviesPlayingTableViewCell: UITableViewCell {
    
    //@IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
