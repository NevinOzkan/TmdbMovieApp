//
//  DetailViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
    weak var delegate: DetailViewModelDelegate?
    var movie: Movie? 
    private let service: MovieServiceProtocol
    
   
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func load(movieID: Int) {

        service.fetchMovieDetails(movieId: movieID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movie):
                self.movie = movie
                self.delegate?.fetchMovieDetails(movie)
                print("Movie başarıyla yüklendi: \(movie.title)")
            case .failure(let error):
                print("Film detayları yüklenirken hata oluştu: \(error)")
            }
        }
    }
}
