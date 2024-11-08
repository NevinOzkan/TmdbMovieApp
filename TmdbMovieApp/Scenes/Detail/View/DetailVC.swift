//
//  DetailVC.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 7.11.2024.
//

import UIKit
import SDWebImage

class DetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    var viewModel: DetailViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.load()
       
    }
}

extension DetailVC: DetailViewModelDelegate {
    func showUpcomingMovies(_ movie: Movie) {
        movieTitleLabel.text = movie.title
        voteLabel.text = "Puan: \(movie.voteAverage ?? 0)/10"
        dateLabel.text = "Çıkış Tarihi: \(movie.releaseDate ?? "Bilgi Yok")"
        overviewTextView.text = movie.overview ?? "Özet mevcut değil"
        
        // Film görselini yüklüyoruz (varsa)
        if let imageUrl = movie.posterPath {
            let fullImageUrl = "https://image.tmdb.org/t/p/w500\(imageUrl)"
            imageView.sd_setImage(with: URL(string: fullImageUrl), placeholderImage: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}
