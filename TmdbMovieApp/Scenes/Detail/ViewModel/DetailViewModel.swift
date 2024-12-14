//
//  DetailViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
    
    weak var delegate: DetailViewModelDelegate?
       private var cachedMovie: MovieModel?

       func load(movieID: Int) {
           
           if let cachedMovie = cachedMovie {
               delegate?.fetchMovieDetails(cachedMovie)
               return
           }
           
           let service = MovieService()
           service.fetchMovieDetails(movieId: movieID) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(let movie):
                   self.cachedMovie = movie
                   self.delegate?.fetchMovieDetails(movie)
               case .failure(let error):
                   self.delegate?.showError("Failed to load movie details: \(error.localizedDescription)")
               }
           }
       }
   }

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    func load(movieID: Int)
}

protocol DetailViewModelDelegate: AnyObject {
    func fetchMovieDetails(_ movie: MovieModel)
    func showError(_ message: String)
}

