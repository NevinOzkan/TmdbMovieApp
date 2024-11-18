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
    
        
        var viewModel: DetailViewModelProtocol! // ViewModel referansı
        var movieID: Int? // Film ID'si
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // ViewModel delegate'ini self yapıyoruz
            viewModel.delegate = self
            
            // Eğer ViewModel'de film ID'si varsa, detayları yükle
            if let movieID = movieID {
                viewModel.load(movieID: movieID)
            } else {
                print("Movie ID is missing!")
            }
        }
    }

    extension DetailVC: DetailViewModelDelegate {
        // ViewModel'den gelen veriyi alıyoruz
        func fetchMovieDetails(_ movie: Movie) {
            DispatchQueue.main.async {
                // UI elemanlarını güncelliyoruz
                self.movieTitleLabel.text = movie.title
                self.voteLabel.text = "\(movie.voteAverage ?? 0)/10"
                self.dateLabel.text = DateFormatterHelper.formattedDate(from: movie.releaseDate)
                self.overviewTextView.text = movie.overview

                // Poster resmi için URL'yi kontrol ediyoruz
                if let imageUrl = movie.posterPath {
                    let fullImageUrl = "https://image.tmdb.org/t/p/w500\(imageUrl)"
                    self.imageView.sd_setImage(with: URL(string: fullImageUrl), placeholderImage: UIImage(named: "placeholder"))
                } else {
                    self.imageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
