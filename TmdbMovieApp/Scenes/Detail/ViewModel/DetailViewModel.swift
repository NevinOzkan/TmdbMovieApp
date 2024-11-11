//
//  DetailViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
    
    var delegate: (any DetailViewModelDelegate)?
    private let service: MovieServiceProtocol
    var movie: Movie
    
    
     init(movie: Movie, service: MovieServiceProtocol) {
         self.movie = movie
         self.service = service
     }
    
    func load() {
        delegate?.showUpcomingMovies(movie)
    }
    
}
