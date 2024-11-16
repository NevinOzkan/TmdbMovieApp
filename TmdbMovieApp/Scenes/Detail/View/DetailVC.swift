//
//  DetailVC.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    
    var viewModel: DetailViewModelProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.load(movieId: 1)
    }
}

extension DetailVC: DetailViewModelDelegate {
    func showMovieDetails(_ movie: Movie) {
        movieTitleLabel.text = movie.title
        voteLabel.text = "\(movie.voteAverage)/10"
        
        dateLabel.text = DateFormatterHelper.formattedDate(from: movie.releaseDate)
        
        overviewTextView.text = movie.overview
        
        if let imageUrl = movie.posterPath {
            let fullImageUrl = "https://image.tmdb.org/t/p/w500\(imageUrl)"
            imageView.sd_setImage(with: URL(string: fullImageUrl), placeholderImage: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        
    }
}
