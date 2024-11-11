//
//  UpcomingCell.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
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
           // Başlık, açıklama ve tarih etiketlerine verileri atıyoruz
           titleLabel.text = model.title
           overviewLabel.text = model.overview
        
        let formattedDateString = DateFormatterHelper.formattedDate(from: model.releaseDate)
        dateLabel.text = formattedDateString
        
           // Görseli yüklerken, varsa SDWebImage veya diğer yöntemleri kullanabilirsiniz
           if let posterPath = model.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
               movieImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
           }
       }
   }