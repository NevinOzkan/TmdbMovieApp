//
//  HomeContracts.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

protocol MovieViewModelProtocol {
    var delegate: MovieViewModelDelegate? { get set }
    var upcomingMovies: [Movie] { get set }
    var nowPlayingMovies: [Movie] { get set }
    var currentPage: Int { get set } // currentPage eklendi
    func loadUpcomingMovies(page: Int)
    func loadNowPlayingMovies()
   
}

enum MovieViewModelOutput {
    case updateUpcomingMovies([Movie])
    case updateNowPlayingMovies([Movie])
}

protocol MovieViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: MovieViewModelOutput)
    func showError(_ message: String) 
}

enum MovieViewRoute {
    case detail(viewModel: DetailViewModelProtocol)
}
