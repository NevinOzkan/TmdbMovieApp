//
//  DetailViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
    
    weak var delegate: DetailViewModelDelegate?
       private var isFetching: Bool = false // Tekil çağrıyı kontrol etmek için
       private var cachedMovie: MovieModel? // Daha önce alınan veriyi saklamak için

       func load(movieID: Int) {
           // Eğer veri önceden alındıysa tekrar çağırma
           if let cachedMovie = cachedMovie {
               delegate?.fetchMovieDetails(cachedMovie)
               return
           }
           
           // Zaten bir istek gönderiliyorsa yeni istek gönderme
           guard !isFetching else { return }
           isFetching = true

           let service = MovieService()
           service.fetchMovieDetails(movieId: movieID) { [weak self] result in
               guard let self = self else { return }
               self.isFetching = false // İstek tamamlandığında sıfırla
               switch result {
               case .success(let movie):
                   self.cachedMovie = movie // Veriyi sakla
                   self.delegate?.fetchMovieDetails(movie)
               case .failure(let error):
                   self.delegate?.showError("Failed to load movie details: \(error.localizedDescription)")
               }
           }
       }
   }
