//
//  DetailViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
    weak var delegate: DetailViewModelDelegate?
    var movie: Movie? // Film verisini saklayacak property
    private let service: MovieServiceProtocol
    
    // Movie ve service parametrelerini alıyoruz
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func load(movieID: Int) {
        print("Loading movie with ID: \(movieID)")
        
        service.fetchMovieDetails(movieId: movieID) { [weak self] result in
            switch result {
            case .success(let moviesResponse):
                guard let movie = moviesResponse.results.first else {
                    print("No movie found")
                    return
                }
                
                // Movie'yi ViewModel'e set ettim
                print("Movie loaded successfully: \(movie.title)")
                self?.movie = movie
                
                // Delegate üzerinden DetailVC'yi bilgilendiriyoruz
                self?.delegate?.fetchMovieDetails(movie)
            case .failure(let error):
                print("Error fetching movie details: \(error)")
            }
        }
    }
}
