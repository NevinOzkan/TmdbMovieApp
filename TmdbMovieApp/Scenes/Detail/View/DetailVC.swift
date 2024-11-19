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
        var movieID: Int?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // ViewModel delegate'ini self yapıyoruz
            viewModel.delegate = self
            
            if let movieID = movieID {
                       print("Loading movie with ID: \(movieID)")
                       viewModel.load(movieID: movieID)
                   } else {
                       print("Movie ID is missing!")
                   }
               }
           }


extension DetailVC: DetailViewModelDelegate {
    func fetchMovieDetails(_ movie: Movie) {
        DispatchQueue.main.async {
            self.movieTitleLabel.text = movie.title
            self.voteLabel.text = "\(movie.voteAverage)/10"
            self.dateLabel.text = DateFormatterHelper.formattedDate(from: movie.releaseDate)
            self.overviewTextView.text = movie.overview
        
            if let imageUrl = movie.posterPath {
                let fullImageUrl = "https://image.tmdb.org/t/p/w500\(imageUrl)"
                self.imageView.sd_setImage(with: URL(string: fullImageUrl), placeholderImage: UIImage(named: "placeholder"))
            } else {
                self.imageView.image = UIImage(named: "placeholder")
            }
        }
    }
}
