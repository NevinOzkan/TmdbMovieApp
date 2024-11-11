//
//  HomeViewModel.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

class HomeViewModel: MovieViewModelProtocol {
    
    
    var delegate: (any MovieViewModelDelegate)?
    private var movies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private let service: MovieServiceProtocol!
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func loadUpcomingMovies(page: Int) {
            notify(.setLoading(true))
            
            service.fetchUpcomingMovies { [weak self] result in
                guard let self = self else { return }
                self.notify(.setLoading(false))
                
                switch result {
                case .success(let response):
                    print("Gelen Upcoming Movies:", response)
                    
                    self.upcomingMovies = response.results
                    self.notify(.updateUpcomingMovies(self.upcomingMovies))
                    
                case .failure(let error):
                    print("API Fetch Hatası: \(error.localizedDescription)")
                }
            }
        }
            
    func loadNowPlayingMovies() {
           notify(.setLoading(true))
           
           service.fetchNowPlayingMovies() { [weak self] result in
               guard let self = self else { return }
               self.notify(.setLoading(false))
               
               switch result {
               case .success(let response):
                   print("Gelen Now Playing Movies:", response)
                   
                   // Filmleri ekleyerek güncelleme yap
                   self.nowPlayingMovies.append(contentsOf: response.results)
                   self.notify(.updateNowPlayingMovies(self.nowPlayingMovies))
                   
               case .failure(let error):
                   print("API Fetch Hatası: \(error.localizedDescription)")
               }
           }
       }
            
            func selectMovie(at index: Int) {
                //TODO
            }
            
            
            private func notify(_ output: MovieViewModelOutput) {
                delegate?.handleViewModelUpcomingOutput(output)
                delegate?.handleViewModelNowPlayingOutput(output)
            }
}
