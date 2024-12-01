//
//  HomeViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class HomeViewModel: MovieViewModelProtocol {
    var currentPage: Int = 0
    var delegate: (any MovieViewModelDelegate)?
    var nowPlayingMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var service = MovieService()
    
    func loadUpcomingMovies(page: Int) {
        service.fetchUpcomingMovies() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.upcomingMovies.append(contentsOf: response.results)
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
