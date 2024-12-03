//
//  HomeViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class HomeViewModel: MovieViewModelProtocol {
    
    var delegate: (any MovieViewModelDelegate)?
    var nowPlayingMovies: [MovieModel] = []
    var upcomingMovies: [MovieModel] = []
    var service = MovieService()
    var currentPage: Int = 1
    var isLoading: Bool = false
    
    func loadUpcomingMovies() {
        service.fetchUpcomingMovies(page: currentPage) { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    self.upcomingMovies.append(contentsOf: response.results)
                    self.currentPage += 1
                    self.notify(.updateUpcomingMovies(self.upcomingMovies))
                case .failure(let error):
                    self.delegate?.showError("Failed to load movie details: \(error.localizedDescription)")
                }
            }
        }
    
    func loadNowPlayingMovies() {
        service.fetchNowPlayingMovies() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.nowPlayingMovies.append(contentsOf: response.results)
                self.notify(.updateNowPlayingMovies(self.nowPlayingMovies))
            case .failure(let error):
                self.delegate?.showError("Failed to load movie details: \(error.localizedDescription)")
            }
        }
    }
   
    private func notify(_ output: MovieViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
}
