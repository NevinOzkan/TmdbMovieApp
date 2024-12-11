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
    var totalPages: Int = 500

    func loadUpcomingMovies() {
        print("*****1 ", isLoading)
        guard currentPage <= totalPages, !isLoading else { return }
        
        isLoading = true
        print("***** 2", isLoading)
        service.fetchUpcomingMovies(page: currentPage) { [weak self] result in
            guard let self else { return }
            
           
            
            switch result {
            case .success(let response):
                self.upcomingMovies.append(contentsOf: response.results)
                
                if let fetchedTotalPages = response.totalPages {
                    self.totalPages = fetchedTotalPages
                }
                self.currentPage += 1
                print("*****3 ", isLoading)
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
