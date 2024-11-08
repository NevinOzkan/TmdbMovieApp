//
//  HomeViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 6.11.2024.
//

import Foundation
import Alamofire

class HomeViewModel: MovieViewModelProtocol {
    
    var delegate: MovieViewModelDelegate?
    private let service: MovieServiceProtocol
    private var movies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
      
    func loadUpcomingMovies() {
        notify(.setLoading(true))
        
        service.fetchUpcomingMovies { [weak self] result in
            guard let self = self else { return }
            self.notify(.setLoading(false))
            
            switch result {
            case .success(let response):
                print("Gelen Upcoming Movies:", response)
                
                self.upcomingMovies = response.results
                self.notify(.movielist(self.upcomingMovies))
                
            case .failure(let error):
                print("API Fetch Hatası: \(error.localizedDescription)")
            }
        }
    }

    func loadNowPlayingMovies() {
        notify(.setLoading(true))
        
        service.fetchNowPlayingMovies { [weak self] result in
            guard let self = self else { return }
            self.notify(.setLoading(false))
            
            switch result {
            case .success(let response):
                print("Gelen Now Playing Movies:", response)
                
                self.nowPlayingMovies = response.results
                self.notify(.movielist(self.nowPlayingMovies))
                
            case .failure(let error):
                print("API Fetch Hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func selectMovie(at index: Int) {
        let movie = nowPlayingMovies[index]

        // Movie ve service parametrelerini geçiriyoruz
        let viewModel = DetailViewModel(movie: movie, service: service)

        // DetailViewModel'i doğru şekilde başlatıyoruz
        let route = MovieViewRoute.detail(viewModel: viewModel)
        delegate?.navigate(to: route)
    }

    
    private func notify(_ output: MovieViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
    
    
}
