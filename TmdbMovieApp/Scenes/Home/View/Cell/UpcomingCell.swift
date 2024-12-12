//
//  UpcomingCell.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import UIKit

class UpcomingCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.layer.cornerRadius = 10
        movieImageView.clipsToBounds = true
    }

    func prepareCell(with model: MovieModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        
        let formattedDateString = DateFormatterHelper.formattedDate(from: model.releaseDate)
        dateLabel.text = formattedDateString
        
           if let posterPath = model.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
               movieImageView.sd_setImage(with: url)
           }
       }
   }


