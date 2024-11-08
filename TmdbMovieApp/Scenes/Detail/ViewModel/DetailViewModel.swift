//
//  DetailViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 7.11.2024.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
    
    var delegate: (any DetailViewModelDelegate)?
    private let service: MovieServiceProtocol
    var movie: Movie

    // `init` fonksiyonu `movie` ve `service` objelerini alır.
    init(movie: Movie, service: MovieServiceProtocol) {
        self.movie = movie
        self.service = service
    }

    // `load` fonksiyonu, `movie` verisini delegate aracılığıyla iletebilir
    func load() {
        // Mevcut movie verisini delegate'e bildiriyoruz
        delegate?.showUpcomingMovies(movie)
        
        // Ayrıca `upcomingMovies`'i çekmek isterseniz, bu kısmı da kullanabilirsiniz.
        service.fetchUpcomingMovies() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("Gelen Upcoming Movies:", response)
               
            case .failure(let error):
                print("API Fetch Hatası: \(error.localizedDescription)")
            }
        }
    }
}
