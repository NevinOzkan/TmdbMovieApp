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
    var movieID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.load(movieID: movieID)
    }
    
    @IBAction func ımdbButton(_ sender: Any) {
        let tmdbURLString = "https://www.themoviedb.org/movie/\(movieID!)"
        
        if let url = URL(string: tmdbURLString) {
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            
            showError("Geçerli bir URL oluşturulamadı.")
        }
    }
}

extension DetailVC: DetailViewModelDelegate {
    
    func fetchMovieDetails(_ movie: MovieModel) {
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
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
