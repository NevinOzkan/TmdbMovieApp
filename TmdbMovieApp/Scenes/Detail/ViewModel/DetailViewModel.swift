//
//  DetailViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
    
    weak var delegate: DetailViewModelDelegate?

        
    func load(movieID: Int) {

        let service = MovieService()
        
        service.fetchMovieDetails(movieId: movieID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let movie):
                self.delegate?.fetchMovieDetails(movie)
                print("Movie başarıyla yüklendi: \(movie.title)")
            case .failure(let error):
                print("Film detayları yüklenirken hata oluştu: \(error)")
            }
        }
    }
}
