//
//  NowPlayingCollectionCell.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 7.11.2024.
//

import UIKit
import SDWebImage

class NowPlayingCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
    }
    
    func prepareCell(with model: Movie) {
        movieTitle.text = model.title
        movieOverview.text = model.overview
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + model.posterPath!) {
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
