//
//  UpcomingCell.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 7.11.2024.
//

import UIKit
import SDWebImage

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

    func prepareCell(with model: Movie) {
           titleLabel.text = model.title
           overviewLabel.text = model.overview
           
           // `model.releaseDate` örnek bir tarih string'i alıyor.
           let formattedDateString = DateFormatterHelper.formattedDate(from: model.releaseDate)
           dateLabel.text = formattedDateString
           
           if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + model.posterPath!) {
               movieImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
           }
       }
   }



