//
//  DetailViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
    
    weak var delegate: DetailViewModelDelegate?
       private var isFetching: Bool = false
       private var cachedMovie: MovieModel?

       func load(movieID: Int) {
           
           if let cachedMovie = cachedMovie {
               delegate?.fetchMovieDetails(cachedMovie)
               return
           }
    
           guard !isFetching else { return }
           isFetching = true

           let service = MovieService()
           service.fetchMovieDetails(movieId: movieID) { [weak self] result in
               guard let self = self else { return }
               self.isFetching = false
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
